from rest_framework import generics, permissions
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.authtoken.serializers import AuthTokenSerializer
from knox.auth import AuthToken#, TokenAuthentication
from .serializers import UserSerializer, RegisterSerializer, InformationSerializer
from django.contrib.auth.models import User, Group
from .models import Information

#used in register API for "user_info" response
def serialize_user(user):
    return {
        "user": user.id,
        "username": user.username,
        "email": user.email,
        "first_name": user.first_name,
        "last_name": user.last_name
    }

#login API
@api_view(['POST'])
def login(request):
    serializer = AuthTokenSerializer(data=request.data)
    serializer.is_valid(raise_exception=True)
    user = serializer.validated_data['user']
    _, token = AuthToken.objects.create(user)
    return Response({
        'user_data': serialize_user(user),
        'token': token
    })

#register API
@api_view(['POST'])
def register(request):
    serializer = RegisterSerializer(data=request.data)
    if serializer.is_valid(raise_exception=True):
        user = serializer.save()
        _, token = AuthToken.objects.create(user)
        user_group = Group.objects.get(name='App User')
        user_group.user_set.add(user)
        return Response({
            "user_info": serialize_user(user),
            "token": token
        })

#User API: GET all registered users list (default data)
@api_view(['GET'])
def all_users(request):
    if request.method == 'GET':
         user = User.objects.all()
         serializer = UserSerializer(user, many=True)
         return Response(serializer.data)

#User API: GET specific registered user data by username (default data)
@api_view(['GET'])
def get_user(request, url):
    try:
        user = User.objects.get(username=url)
    except User.DoesNotExist:
         return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = UserSerializer(user)
        return Response({"user_info": serializer.data})

#Information API: all users' information
@api_view(['GET', 'POST'])
def info_list(request):
    if request.method == 'GET': #GET all users' username, preference
        info = Information.objects.all()

        serializer = InformationSerializer(info, many=True)
        return Response({"serialize_all_info": serializer.data})

    elif request.method == 'POST': #POST a new user's username, preference
        serializer=InformationSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

#Information API: specific user's information
@api_view(['GET', 'PUT'])
def info_specific(request, url):
    try:
        info = Information.objects.get(username=url)
    except Information.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET': #GET specific username's data preference
        serializer = InformationSerializer(info)
        return Response({"serialize_specific_info": serializer.data})

    elif request.method == 'PUT': #PUT(edit) data on specific username
        serializer = InformationSerializer(info, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

#Information API: Upload profile picture to a specific user
@api_view(['POST'])
def upload_image(request, url):
    data = request.data

    obj_username = data['username']
    info = Information.objects.get(id=obj_username)

    info.profile_pic = request.FILES.get('profile_pic')
    info.save()

    return Response('Image was uploaded')