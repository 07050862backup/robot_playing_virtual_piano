"""水平投影+垂直投影找到鋼琴黑鍵"""
import cv2
import numpy as np


def return_longest_list(a):
    # a  = [[0,0],[1,1,1],[0,0],[2,2,2,2,2,2],[0],[0],[3,3],[0],[4],[0,0],[5,666]]
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
    print('Maximum value:', max_value, "At index: ", a[max_idx])  # Maximum value: 6 At index:  [2, 2, 2, 2, 2, 2]
    return a[max_idx]
def get_vvList(list_data):
    #取出list中畫素存在的區間
    print("len有%s"%len(list_data))
    print("全部有%s"%list_data)
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
def Horizontal_project(thresh1):
    thresh1_copy = thresh1.copy()
    (h, w) = thresh1_copy.shape  # 返回高和寬
    # 記錄每一列的波峰
    b = [0 for z in range(0, h)]  # a = [0,0,0,0,0,0,0,0,0,0,...,0,0]初始化一個長度為w的陣列，用於記錄每一列的黑點個數
    for j in range(0, h):
        for i in range(0, w):
            if thresh1_copy[j, i] == 0:
                b[j] += 1
                thresh1_copy[j, i] = 255
    for j in range(0, h):
        for i in range(0, b[j]):
            thresh1_copy[j, i] = 0
    # 如果要分割字元的話，其實並不需要把這張圖給畫出來，只需要的到b=[]即可得到想要的資訊

    finish_project_h1 = np.zeros((192, 256), np.uint8)  # 將多餘的水平投影消除
    # 使用白色填充圖片區域,默認為黑色

    finish_project_h1.fill(255)
    for j in range(0, h):
        for i in range(0, b[j]):
            if 200 >b[j] and b[j] > 110:
                finish_project_h1[j, i] = 0
            else:
                b[j]=0

    return thresh1_copy,finish_project_h1,b
def vertical_project(thresh1):

    thresh1_copy = thresh1.copy()
    (h, w) = thresh1_copy.shape  # 返回高和寬
    # 記錄每一列的波峰
    a = [0 for z in range(0, w)]  # a = [0,0,0,0,0,0,0,0,0,0,...,0,0]初始化一個長度為w的陣列，用於記錄每一列的黑點個數
    for j in range(0, w):  # 遍歷一列
        for i in range(0, h):  # 遍歷一行
            if thresh1_copy[i, j] == 0:  # 如果改點為黑點
                a[j] += 1  # 該列的計數器加一計數
                thresh1_copy[i, j] = 255  # 記錄完後將其變為白色
    for j in range(0, w):  # 遍歷每一列
        for i in range((h - a[j]), h):  # 從該列應該變黑的最頂部的點開始向最底部塗黑
            thresh1_copy[i, j] = 0  # 塗黑

    return thresh1_copy,a
def vertical_thershols(vertical_thresh1,a):
    vertical_thresh1_copy = vertical_thresh1.copy()
    (h, w) = vertical_thresh1_copy.shape  # 返回高和寬


    finish_project_v1 = np.zeros((192,256), np.uint8)#將多餘的垂直投影消除
    finish_project_v2 = np.zeros((192, 256), np.uint8)  # 將多餘的垂直投影消除
    # 使用白色填充图片区域,默认为黑色
    finish_project_v1.fill(255)
    finish_project_v2.fill(255)
    threshold_value = 130
    for j in range(0, w):  # 遍歷每一列
        for i in range((h - a[j]), h):  # 從該列應該變黑的最頂部的點開始向最底部塗黑
            if threshold_value < a[j] :  #第一次篩選
                finish_project_v1[i, j] = 0  # 塗黑
    element = cv2.getStructuringElement(cv2.MORPH_OPEN, (3, 3))
    finish_project_v2 = cv2.morphologyEx(finish_project_v1, cv2.MORPH_ERODE, element)  # 第二次篩選
    for j in range(0, w):  # 遍歷每一列
        for i in range((h - a[j]), h):  # 從該列應該變黑的最頂部的點開始向最底部塗黑
            if threshold_value < a[j]:  #第一次篩選
                finish_project_v2[i, j] = 0  # 塗黑
            else:
                a[j] = 0
    return finish_project_v2
def return_black_coordinate(img,black_list):

    GrayImage = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)  # 將BGR圖轉為灰度圖
    ret, thresh1 = cv2.threshold(GrayImage, 130, 255, cv2.THRESH_BINARY)  # 將圖片進行二值化（130,255）之間的點均變為255（背景）
    cv2.imshow('thresh1',thresh1)#二值化的圖

    project_v,a = vertical_project(thresh1)
    finish_project_v = vertical_thershols(project_v, a)
    project_v, a = vertical_project(finish_project_v)

    project_h,finish_project_h,b = Horizontal_project(thresh1)
    # b = return_longest_list(b)
    cv2.imshow('project_v', project_v)
    cv2.imshow('project_h', project_h)
    # project_v,finish_project_v,a = vertical_project(finish_project_v)
    # project_h,finish_project_h,b = Horizontal_project(finish_project_h)
    result = img.copy()
    print("a = ",a)
    print("b = ",b)
    print("a有%s個" %len(a))
    print("b有%s個" %len(b))#b =  [0, 0, 0, 0, 0, 0, 0, 0, 184, 186, 190, 0, 0, 0, 141, 139, 139, 139...]
    b = get_vvList(b)
    b = return_longest_list(b)
    print("這裡啦啦啦%s"%b)
    # 切割單一字元
    # index_verhight = next((i for i, x in enumerate(b) if x), None)#黑鍵範圍最高點
    # index_verlow = [i for i,v in enumerate(b) if v==0 and i>index_verhight][0]#黑鍵範圍最低點
    index_verhight = b[0]
    index_verlow = b[-1]
    # print("黑鍵範圍最高點 : %s,黑鍵範圍最低點:%s"%(index_verhight,index_verlow))
    # print("%s and %s" %(b[index_verhight],b[index_verlow]))
    vv_list = get_vvList(a)

    print("vvlist==%s"%vv_list)
    print("vvlist有%s個" % len(vv_list))
    # print("vvlist==%s"%len(vv_list[1]))
    dellist=[]
    for i in range(len(vv_list)):
        if  i==0 or i== len(vv_list)-1 or len(vv_list[i])<4:#如果拍到影像較近，就要加這行做篩選len(vv_list[i])<4
            continue
        else:
            dellist.append(vv_list[i])
    print("找到 %s 個黑鍵"%len(dellist))
    print("dellist==%s"%dellist)
    vv_list = []
    vv_list =dellist
    xy_old_coordinate = np.empty([len(black_list), 2], dtype="int32")
    iter=0
    for i in vv_list:
        img_ver = img[:, i[0]:i[-1]]
        print("%s%s"%(i[0],i[-1]))
        # cv2.imshow('split', img_ver)
        cv2.rectangle(result, (i[0],index_verlow), (i[-1],index_verhight), (0, 0, 255))
        xy_old_coordinate[iter][0], xy_old_coordinate[iter][1] ,iter= int((i[0] +i[-1]) / 2), int((index_verhight+index_verlow) / 2),iter+1
        print()
    xy_old_coordinate = np.asarray(sorted(xy_old_coordinate, key=lambda s: s[0]), dtype="int32")
    print("xy_old_coordinate=%s",xy_old_coordinate)
    # for i in range(len(xy_old_coordinate)):
    #     cv2.circle(result, (xy_old_coordinate[i][0], xy_old_coordinate[i][1]), 1, (0, 255, 0), -1)

    cv2.imshow('showlist', img)

    # cv2.imshow('project_v', project_v)
    cv2.imshow('finish_project_v',finish_project_v)
    # cv2.imshow('project_h', project_h)
    cv2.imshow('finish_project_h',finish_project_h)
    cv2.namedWindow("result", cv2.WINDOW_NORMAL)
    cv2.imshow("result",result)
    #cv2.waitKey(0)

    #cv2.destroyAllWindows()
    return xy_old_coordinate