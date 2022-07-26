"""舊檔案，可刪除"""
import cv2
import numpy as np
def get_vvList(list_data):
    #取出list中畫素存在的區間
    vv_list=list()
    v_list=list()
    for index,i in enumerate(list_data):
        if i>0:
            v_list.append(index)
        else:
            if v_list:
                vv_list.append(v_list)
                #list的clear與[]有區別
                v_list=[]
    print(vv_list)
    print(v_list)
    vv_list.append(v_list)
    return vv_list
def return_longest_list(a):

    #a  = [[0,0],[1,1,1],[0,0],[2,2,2,2,2,2],[0],[0],[3,3],[0],[4],[0,0],[5,666]]
    # b = get_vvList(a)
    index_len = []
    for i in range(len(a)):
        index_len.append(len(a[i]))

    max_value = None
    max_idx = None

    for idx, num in enumerate(index_len):
        if (max_value is None or num > max_value):
            max_value = num
            max_idx = idx
    print('Maximum value:', max_value, "At index: ", a[max_idx])#Maximum value: 6 At index:  [2, 2, 2, 2, 2, 2]
    return a[max_idx]
