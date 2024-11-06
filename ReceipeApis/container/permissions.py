from rest_framework.permissions import BasePermission

class IsOwner(BasePermission):
    def has_object_permission(self, request, view, obj):
      

        if obj.receipe_user_id:
  
            obj.receipe_user_id ==  request.user
        return False    
    