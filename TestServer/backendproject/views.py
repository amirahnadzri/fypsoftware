#to create endpoint (access data)
from django.http import JsonResponse
from .models import User
from .serializers import UserSerializer
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status

from backendproject import serializers

@api_view(['GET', 'POST'])
def user_list(request, format=None):
    #GET
    #get all users
    #serialize them
    #return json
    if request.method == 'GET': #get data from database
        users = User.objects.all()
        serializer = UserSerializer(users, many=True)
        #return JsonResponse({"users": serializer.data}, safe=False) #return json
        return Response(serializer.data) #return django html


    if request.method == 'POST':
        serializer =UserSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)

@api_view(['GET', 'PUT', 'DELETE'])
def user_detail(request, id, format=None):
    try:
        users = User.objects.get(pk=id) #pk is primary key
    except User.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = UserSerializer(users)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer =UserSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    elif request.method == 'DELETE':
        users.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)