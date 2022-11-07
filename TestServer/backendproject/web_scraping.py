import requests
from bs4 import BeautifulSoup
import requests
import sys
from selenium import webdriver
from selenium.webdriver.common.by import By

sys.path.insert(0,'/usr/lib/chromium-browser/chromedriver')

options = webdriver.ChromeOptions()
options.add_argument('--headless')
options.add_argument('--no-sandbox')
options.add_argument('--disable-dev-shm-usage')

"""This function is to check if it is a chemical"""
def get_idfromkeyword_chebicheck(keyword):
    URL = "https://ontobee.org/search?ontology=&keywords="+keyword+"&submit=Search+terms"
    searchpage = requests.get(URL)
    soup = BeautifulSoup(searchpage.text,'html.parser')
    try:
      litag = soup.find_all('li')[2]
      atag = litag.find_all('a')[0]
      onto_id = atag['href'].split("/")
      return onto_id[len(onto_id)-1]
    except IndexError:
      return "cannot find"

"""This function is to get the id from item name"""
def get_idfromkeyword(keyword):
    URL = "https://ontobee.org/search?ontology=FOODON&keywords="+keyword+"&submit=Search+terms"
    searchpage = requests.get(URL)
    soup = BeautifulSoup(searchpage.text,'html.parser')
    litag = soup.find_all('li')[0]
    atag = litag.find_all('a')[0]
    onto_id = atag['href'].split("/")
    return onto_id[len(onto_id)-1]

def get_id_error_res(keyword, i):
    URL = "https://ontobee.org/search?ontology=FOODON&keywords="+keyword+"&submit=Search+terms"
    searchpage = requests.get(URL)
    soup = BeautifulSoup(searchpage.text,'html.parser')
    litag = soup.find_all('li')[i]
    atag = litag.find_all('a')[0]
    onto_id = atag['href'].split("/")
    return onto_id[len(onto_id)-1]

"""This function is to get the id from item if it is not FOODON"""
def get_idfromkeyword2(keyword):
    URL = "https://ontobee.org/search?ontology=FOODON&keywords="+keyword+"&submit=Search+terms"
    searchpage = requests.get(URL)
    soup = BeautifulSoup(searchpage.text,'html.parser')
    try:
      litag = soup.find_all('li')[4]
    except IndexError:
      litag = soup.find_all('li')[2]
    atag = litag.find_all('a')[0]
    onto_id = atag['href'].split("/")
    return onto_id[len(onto_id)-1]

"""This function is to get the parents list"""
def get_category(keyword_id, keyword, i):
      wd = webdriver.Chrome('chromedriver',options=options)
      wd.get("https://ontobee.org/ontology/FOODON?iri=http://purl.obolibrary.org/obo/"+keyword_id)
      h1 = wd.find_elements(By.CLASS_NAME, value="hierarchy")
      
      try:
        list1 = h1[0].text
      except IndexError:
        return get_category(get_id_error_res(keyword, i+1), keyword, i+1)
      list1 = list1.replace("+",",")
      list1 = list1.replace("-",",")
      parents = list1.split(",")

      res = []
      for ele in parents:
          ele = ele.strip()
          ele = ele.replace("\n","")
          res.append(ele)
      
      wd.quit()
      return res


def get_category_alcohol(keyword_id, keyword, i):
      wd = webdriver.Chrome('chromedriver',options=options)
      wd.get("https://ontobee.org/ontology/NCIT?iri=http://purl.obolibrary.org/obo/"+keyword_id)
      h1 = wd.find_elements(By.CLASS_NAME, value="hierarchy")
      
      try:
        list1 = h1[0].text
      except IndexError:
        return "alcohol"
      list1 = list1.replace("+",",")
      list1 = list1.replace("-",",")
      parents = list1.split(",")

      res = []
      for ele in parents:
          ele = ele.strip()
          ele = ele.replace("\n","")
          res.append(ele)
      
      wd.quit()
      return res

def final_category(category_list):
      to_find = [ "beef", "pork", "chicken","egg","nut", "dairy","milk","fish","grain", "seafood","vegetable","fruit","nut", "dairy","milk", "alcohol", "herb","plant", "animal", "water", "chemical"]
      count = 0
      
      category_list = [each_string.lower() for each_string in category_list]
      for find in to_find:
        str_match = list(filter(lambda x: find in x, category_list))
        if str_match:
          break
        count = count + 1
      if count == 21:
        return "not in category"
      if to_find[count] == "fruit" or to_find[count] == "vegetable" or to_find[count] == "herb" :
        return to_find[12]
      return to_find[count]

def main(ingredient):
  test = ingredient.split(" ")
  ingredient = ingredient.replace(" ","+")
  trigger = [ "corn", "seed", "beans", "peas", "soy", "wine","coconut","cream"]
  test = [each_string.lower() for each_string in test]
  if final_category(test) == "not in category" or final_category(test) == "nut":
    count2 = 0
    for find in trigger:
      str_match = list(filter(lambda x: find in x, test))
      if str_match:
        break
      count2 = count2 + 1
      if count2 == 7:
        break
    if count2 < 7:
      if (trigger[count2] == "corn") or (trigger[count2] == "coconut") or (trigger[count2] == "seed") or (trigger[count2] == "corn") or (trigger[count2] == "peas") or (trigger[count2] == "beans") or (trigger[count2] == "soy"):
        return "plant"
      elif (trigger[count2] == "cream"):
        return "milk"
      elif (trigger[count2] == "wine"):
        return "alcohol"
  try:
    keyword_id = get_idfromkeyword(ingredient)
  except IndexError:
    ingredient = ingredient.split("+")
    if len(ingredient) == 0:
      return "not in ontology" 
    else:
      del ingredient[0]
      ingredient = "+".join(ingredient)
      return main(ingredient)
  chebi_check = keyword_id[0:5]
  keyword_id2 = get_idfromkeyword_chebicheck(ingredient)
  chebi_check2 = keyword_id2[0:5]
  if chebi_check == "CHEBI" :
    return "Chemical"
  elif chebi_check2 == "CHEBI" :
    return "Chemical"
  else: 
    foodon_check = keyword_id[0:6]
    if not foodon_check == "FOODON":
      keyword_id = get_idfromkeyword2(ingredient)
    category_list = get_category(keyword_id, ingredient,i)
    result = final_category(category_list)
    if result == "alcohol":
      category_list = get_category_alcohol(keyword_id, ingredient,i)
      result = final_category(category_list)
      
  return result
  
i = 0