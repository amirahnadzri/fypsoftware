#to create endpoint (access data)
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .web_scraping import main
from .mp_query import multi
from .load_model import model_result, numbering

#GET API to check the dietary preference label for the ingredients given
@api_view(['GET'])
def CheckIngredient(request, url):
    num = url.count(',')+1
    if num > 1:
        ing_list = url.split(',') #make an array
        result_list=multi(ing_list) #categories
        final = model_result(result_list) #label
        array_numbering = numbering(result_list)

    else:
        ing_list = url
        result_list = main(ing_list) #categories
        final = model_result(result_list) #label
        array_numbering = numbering(result_list)


    if final == 1:
        final_label = 'vegan'
    if final == 2:
        final_label = 'lacto'
    if final == 3:
        final_label = 'none'
    if final == 4:
        final_label = 'ovo'
    if final == 5:
        final_label = 'pollo'
    if final == 6:
        final_label = 'pesco'
    if final == 7:
        final_label = 'lactoovo'

    return Response({"ingredient_given": ing_list, "category": result_list, "array_numbering": array_numbering, "label_number": final, "label": final_label})

