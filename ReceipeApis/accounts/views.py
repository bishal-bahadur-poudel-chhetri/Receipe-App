import random
from django.shortcuts import render
from accounts.models import Account
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from accounts.serializers import ChangePasswordSerializer, UserRegisterSerializer
from recipe import settings
from rest_framework_simplejwt.tokens import RefreshToken, TokenError
from datetime import timedelta
from rest_framework.permissions import IsAuthenticated
from container.permissions import IsOwner
from django.core.mail import send_mail

class RegisterAPIView(APIView):
    serializer_class = UserRegisterSerializer

    def post(self, request, format=None):
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            refresh = RefreshToken.for_user(user)
            refresh.access_token.set_exp(lifetime=timedelta(days=7))  # Set access token expiration to 7 days
            responsedata = {
                'refresh': str(refresh),
                'access': str(refresh.access_token),
                'user': str(serializer.data)
            }
            return Response(responsedata, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class LogoutAPIView(APIView):
    def post(self, request, format=None):
        try:
            refresh_token = request.data['refresh_token']
            tokens_obj = RefreshToken(refresh_token)
            tokens_obj.blacklist()
            return Response("Successful Logout", status=status.HTTP_200_OK)
        except Exception as e:
            print(e)
            return Response(status=status.HTTP_400_BAD_REQUEST)


class OTPAPIView(APIView):
    permission_classes=[IsAuthenticated,IsOwner]
    def send_otp(self,email):
        subject='Your account Verification Email'
        otp=random.randint(1000,9999)
        email_from=settings.EMAIL_HOST_USER
        message=f'your otp is {otp}'
        try:
            send_mail(subject,message,email_from,[email])
            print(Account.objects.get(email=email))
            user_obj=Account.objects.get(email=email)
            print(user_obj)
        
            user_obj.otp=otp
            user_obj.save()
            return otp,email
        except:
            print("errors")

    def get(self,request,format=None):
        try:
           email=Account.objects.get(username=request.user).email
           print(email)
           self.send_otp(email)

           responsedata = {
            'email': email,
            'status':status.HTTP_200_OK
            }
           return Response(responsedata, status=status.HTTP_200_OK)
         
        except Exception as e:
            print(e)
            return Response(status=status.HTTP_400_BAD_REQUEST)
    

class OTPVERIFYAPIView(APIView):
    permission_classes=[IsAuthenticated,IsOwner]
    def post(self,request,format=None):
        email=Account.objects.get(username=request.user).email
        userotp=request.data['userotp']
        user_with_email=Account.objects.filter(email=email)
        if user_with_email.exists():
            print("hello")
            otp = user_with_email.first().otp
            if userotp == otp:
                temp_verified=user_with_email.first()
                temp_verified.is_verified=True
                temp_verified.save()
                print("all ok good to gos")
                return Response({'detail': 'otp verified','status':status.HTTP_200_OK}, status=status.HTTP_200_OK)
            else:
                return Response({'detail': 'wrong otp','status':status.HTTP_200_OK}, status=status.HTTP_404_NOT_FOUND)
        else:
            return Response({'detail': 'User not found.'}, status=status.HTTP_404_NOT_FOUND)
         
class ChangePasswordView(APIView):
    permission_classes = [IsAuthenticated,IsOwner]

    def post(self, request):
        serializer = ChangePasswordSerializer(data=request.data)

        if serializer.is_valid():
            user = self.request.user
            old_password = serializer.validated_data.get('old_password')
            new_password = serializer.validated_data.get('new_password')

            if user.check_password(old_password):
                user.set_password(new_password)
                user.save()
                return Response({'message': 'Password changed successfully'}, status=status.HTTP_200_OK)
            else:
                return Response({'message': 'Old password is incorrect'}, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class check_verification_status(APIView):
    permission_classes=[IsAuthenticated,IsOwner]
    def get(self,request,format=None):
        try:
            check_verificatoin=Account.objects.get(username=request.user).is_verified
            print("ok")
        
    
        
            if check_verificatoin==True:          
                return Response({'status': status.HTTP_200_OK, 'result': True}, status=status.HTTP_200_OK)
    
            else:
                return Response({'status': status.HTTP_200_OK, 'result': False}, status=status.HTTP_200_OK)

                          
        except Exception as e:
            print(e)
            return Response(status=status.HTTP_400_BAD_REQUEST)
    

