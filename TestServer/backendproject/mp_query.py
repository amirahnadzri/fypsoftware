from web_scraping import *

from multiprocessing import Process, Manager
from time import sleep

pros = []
final = []

def query(arg,IniCat):
    result = main(arg)
    IniCat.append(result)
    sleep(1)

def multi(arg):
    with Manager() as manager:
      IniCat = manager.list()
      for i in arg:
        p = Process(target=query, args=(i, IniCat))
        pros.append(p)
        p.start()

      # block until all process finish 
      for t in pros:
        t.join()
      for z in IniCat:
        final.append(z)
    return final