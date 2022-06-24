from django.db import models

class User(models.Model):
    firstname = models.CharField(max_length=300)
    lastname = models.CharField(max_length=300)
    _email = models.CharField(max_length=100)
    _password = models.CharField(max_length=100)

    def __str__(self):
        return self.firstname + ' ' + self.lastname 