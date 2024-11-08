from rest_framework import serializers
from container.models import *
from django.contrib.auth import get_user_model
User=get_user_model()


class UserRegisterSerializer(serializers.ModelSerializer):
    password=serializers.CharField(required=True,write_only=True)
    password2=serializers.CharField(required=True,write_only=True)

    class Meta:
        model=User
        fields=[
        'username',
        'email',
        'password',
        'password2', 
        ]
        extra_kwargs={
            'password':{'write_only':True},
            'password':{'write_only':True},
        }
    def create(self, validated_data):
        username=validated_data.get("username")
        email=validated_data.get("email")
        password=validated_data.get("password")
        password2=validated_data.get("password2")
        if password == password2:
            user=User(username=username,email=email)
            user.set_password(password)
            user.save()
            return user
        else:
            raise serializers.ValidationError({
                'error':'password dont match'
            })
        return super().create(validated_data)


class ChangePasswordSerializer(serializers.Serializer):
    old_password = serializers.CharField(required=True)
    new_password = serializers.CharField(required=True)