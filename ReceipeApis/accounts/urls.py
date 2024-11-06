from django.urls import path
from rest_framework_simplejwt import views as jwt_views

from accounts.views import (
    ChangePasswordView,
    OTPAPIView,
    OTPVERIFYAPIView,
    RegisterAPIView,
    LogoutAPIView,
    check_verification_status
    )

urlpatterns = [
    path('api/token/', jwt_views.TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', jwt_views.TokenRefreshView.as_view(), name='token_refresh'),
    path('api/register/', RegisterAPIView.as_view()),
    path('api/logout/', LogoutAPIView.as_view(), name='token_refresh'),
    path('api/otp/', OTPAPIView.as_view()),
    path('api/verifyotp/', OTPVERIFYAPIView.as_view()),
    path('api/changepassword/', ChangePasswordView.as_view()),
    path('api/check/', check_verification_status.as_view()),
 


]