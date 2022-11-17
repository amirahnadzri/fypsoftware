from .web_scraping import main
from multiprocessing import Process, Manager
from time import sleep

def query(arg,IniCat):
    result = main(arg)
    IniCat.append(result)
    sleep(4)

def multi(arg):
    with Manager() as manager:
      IniCat = manager.list()
      IniCat[:] = []
      pros = []
      for i in arg:
        p = Process(target=query, args=(i, IniCat))
        pros.append(p)
        p.start()

      # block until all process finish
      for t in pros:
        t.join()
      final = []
      for z in IniCat:
        final.append(z)
    return final