# -*- coding: utf-8 -*-
"""load_model

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/12jQp7Y3aXgtaWp5R4AxTKiZS7VgFSnWa
"""

import pickle
import numpy as np
import pandas as pd
import warnings
warnings.filterwarnings("ignore")

def numbering(categories):
    label = [0.0,0.0,0.0,0.0,0.0,0.0,0.0]

    for i in range(len(categories)):
        if categories[i] == 'poultry' or categories[i] == 'chicken' :
            label[0] = 1.0
        elif categories[i] == 'beef' or categories[i] == 'animal':
            label[1] = 1.0
        elif categories[i] == 'pork':
            label[2] = 1.0
        elif categories[i] == 'dairy' or categories[i] == 'milk':
            label[3] = 1.0
        elif categories[i] == 'egg':
            label[4] = 1.0
        elif categories[i] == 'grain' or categories[i] == 'nut':
            label[5] = 1.0
        elif categories[i] == 'seafood' or categories[i] == 'fish':
            label[6] = 1.0
    return label


def model_result(input):
    num_label = numbering(input)

    column_name = ['Poultry', 'Beef', 'Pork', 'Dairy', 'Egg', 'Grain', 'Seafood']
    testing = pd.DataFrame(columns = column_name)
    testing.loc[-1] = num_label
    testing.index = testing.index + 1
    testing = testing.sort_index()
    testing = np.array(testing)

    filename = '/home/amirahnadzri/fypsoftware/TestServer/backendproject/finalized_model.sav'

    loaded_model = pickle.load(open(filename, 'rb'))

    result = loaded_model.predict(testing)

    return result