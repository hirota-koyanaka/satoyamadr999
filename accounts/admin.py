from django.contrib import admin
from django.utils import timezone
from django.contrib import messages
from django.contrib.admin import helpers
from django.core.exceptions import PermissionDenied
from django.template.response import TemplateResponse
from .models import User


@admin.action(description="選択したユーザーを承認する")
def approve_users(modeladmin, request, queryset):
    """選択したユーザーを承認するアクション"""
    approved_count = 0
    for user in queryset:
        if user.status == "pending":
            user.approve(approver=request.user)
            approved_count += 1
    
    if approved_count > 0:
        modeladmin.message_user(
            request,
            f"{approved_count}件のユーザーを承認しました。",
            messages.SUCCESS,
        )
    else:
        modeladmin.message_user(
            request,
            "承認待ちのユーザーが選択されていません。",
            messages.WARNING,
        )


@admin.action(description="選択したユーザーを拒否する")
def reject_users(modeladmin, request, queryset):
    """選択したユーザーを拒否するアクション"""
    rejected_count = 0
    for user in queryset:
        if user.status == "pending":
            user.reject()
            rejected_count += 1
    
    if rejected_count > 0:
        modeladmin.message_user(
            request,
            f"{rejected_count}件のユーザーを拒否しました。",
            messages.SUCCESS,
        )
    else:
        modeladmin.message_user(
            request,
            "承認待ちのユーザーが選択されていません。",
            messages.WARNING,
        )


@admin.action(description="選択した承認済みユーザーを削除する", permissions=["delete"])
def delete_approved_users(modeladmin, request, queryset):
    """承認済みユーザーを削除するアクション（確認ページ付き）"""
    # 承認済みユーザーのみをフィルタリング
    approved_users = queryset.filter(status="approved")
    
    if not approved_users.exists():
        modeladmin.message_user(
            request,
            "承認済みのユーザーが選択されていません。",
            messages.WARNING,
        )
        return None
    
    opts = modeladmin.model._meta
    
    # 削除可能なオブジェクトと関連オブジェクトを取得
    (
        deletable_objects,
        model_count,
        perms_needed,
        protected,
    ) = modeladmin.get_deleted_objects(approved_users, request)
    
    # 権限チェック
    if perms_needed:
        raise PermissionDenied
    
    # 確認ページを表示（POSTでpostパラメータがない場合）
    if not request.POST.get("post"):
        context = {
            **modeladmin.admin_site.each_context(request),
            "title": "承認済みユーザーの削除確認",
            "subtitle": None,
            "objects": approved_users,
            "deletable_objects": [deletable_objects],
            "model_count": dict(model_count).items(),
            "queryset": approved_users,
            "perms_lacking": perms_needed,
            "protected": protected,
            "opts": opts,
            "action_checkbox_name": helpers.ACTION_CHECKBOX_NAME,
            "media": modeladmin.media,
        }
        
        request.current_app = modeladmin.admin_site.name
        
        return TemplateResponse(
            request,
            "admin/delete_selected_confirmation.html",
            context,
        )
    
    # 確認済みの場合、削除を実行
    if request.POST.get("post") and not protected:
        deleted_count = approved_users.count()
        
        # 削除対象のユーザー情報をログに記録
        for user in approved_users:
            user_display = str(user)
            modeladmin.log_deletion(request, user, user_display)
        
        # ユーザーを削除
        approved_users.delete()
        
        modeladmin.message_user(
            request,
            f"{deleted_count}件の承認済みユーザーを削除しました。",
            messages.SUCCESS,
        )
        
        # Noneを返すと変更リストページが表示される
        return None
    
    # 保護されたオブジェクトがある場合
    if protected:
        modeladmin.message_user(
            request,
            f"{len(protected)}件のユーザーは保護されているため削除できません。",
            messages.ERROR,
        )
        return None


@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    """ユーザー管理画面のカスタマイズ"""
    list_display = [
        "email",
        "get_full_name_display",
        "status",
        "created_at",
        "approved_at",
        "approved_by",
    ]
    list_filter = [
        "status",
        "created_at",
        "approved_at",
    ]
    search_fields = [
        "email",
        "first_name",
        "last_name",
    ]
    readonly_fields = [
        "created_at",
        "approved_at",
        "approved_by",
        "last_login",
        "date_joined",
    ]
    fieldsets = (
        ("基本情報", {
            "fields": ("email", "first_name", "last_name", "password")
        }),
        ("承認情報", {
            "fields": ("status", "approved_at", "approved_by")
        }),
        ("権限", {
            "fields": ("is_staff", "is_superuser", "is_active", "groups", "user_permissions")
        }),
        ("日時情報", {
            "fields": ("created_at", "last_login", "date_joined")
        }),
    )
    actions = [approve_users, reject_users, delete_approved_users]
    
    def get_full_name_display(self, obj):
        """フルネームを表示"""
        return obj.get_full_name()
    get_full_name_display.short_description = "名前"
    
    def get_queryset(self, request):
        """クエリセットを最適化"""
        qs = super().get_queryset(request)
        return qs.select_related("approved_by")
    
    def save_model(self, request, obj, form, change):
        """モデル保存時の処理"""
        if not change:  # 新規作成時
            # パスワードが設定されている場合はハッシュ化
            if "password" in form.changed_data:
                obj.set_password(obj.password)
        else:  # 更新時
            # パスワードが変更された場合はハッシュ化
            if "password" in form.changed_data:
                obj.set_password(obj.password)
        super().save_model(request, obj, form, change)
