from django.db import models

class Information(models.Model):
    username = models.CharField(max_length=100, null=True)
    preference = models.CharField(max_length=100)
    profile_pic = models.ImageField(null=True, blank=True)

    def __str__(self):
        return self.username