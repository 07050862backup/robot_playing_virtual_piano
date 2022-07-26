
import numpy as np
import kinematics as kin

xyz_array = np.array([[0], [15], [ 0 ]]) # 目標點

print()
""" 第一顆另外算，幾何法  """
theta_1 = np.arctan2(xyz_array[1], xyz_array[0])
""" 定義參數 關節數+DH參數"""
JOINT_SIZE = 4+1
a     = np.transpose([[7, 7, 7, 7.5]])
alpha = np.transpose([[0, 0, 0, 0]])*np.pi/180
d     = np.transpose([[0, 0, 0, 0]])
cta   = np.transpose([[0, 0, 0, 0]])*np.pi/180
""" 計算正運動學"""
T = np.array([[[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]]]*5, dtype=object)
P = np.array([[0, 0, 0]]*5, dtype=object)
R = np.array([[[1, 0, 0], [0, 1, 0], [0, 0, 1]]]*5, dtype=object)

for k in range(1, JOINT_SIZE):
    T[k] = np.dot(T[k-1], np.asarray(kin.DH(a[k-1], alpha[k-1], d[k-1], cta[k-1]), dtype=float))

    P[k][0] = T[k][0][3]
    P[k][1] = T[k][1][3]
    P[k][2] = T[k][2][3]
    R[k] = T[k][0:3, 0:3]
""" 迭代法求逆解"""
b = []
#for i in range(len(xyz_array)):
#    b.append(float(sum(xyz_array[i])))
#xyz_array = np.asarray(b, dtype=float)
target = np.array([[np.hypot(xyz_array[0], xyz_array[1])], [xyz_array[2]-5], [-90*np.pi/180.0]]) # 目標點
print("x = %sxxx" % np.hypot(xyz_array[0], xyz_array[1]))
print("y = %syyy" % [xyz_array[2]-5] )
PATH_SIZE = 20
save_cta = np.zeros((4, PATH_SIZE))
cta_temp = np.array([0,0,0,0])
for i in range(0,PATH_SIZE):
    save_cta[0, i] = cta[0]
    save_cta[1, i] = cta[1]
    save_cta[2, i] = cta[2]
    save_cta[3, i] = cta[3]

    # 誤差
    error = np.array([target[0] - P[JOINT_SIZE-1][0]   , target[1] - P[JOINT_SIZE-1][1],    target[2] - (cta[0] + cta[1] + cta[2] + cta[3])] )

    Jacob0 = [    [[-a[3]*np.sin(cta[0]+cta[1]+cta[2]+cta[3])-a[1]*np.sin(cta[0]+cta[1])-a[0]*np.sin(cta[0])-a[2]*np.sin(cta[0]+cta[1]+cta[2])]   ,  [-a[3]*np.sin(cta[0]+cta[1]+cta[2]+cta[3])-a[1]*np.sin(cta[0]+cta[1])-a[2]*np.sin(cta[0]+cta[1]+cta[2])]   ,[-a[3]*np.sin(cta[0]+cta[1]+cta[2]+cta[3])-a[2]*np.sin(cta[0]+cta[1]+cta[2]) ],[-a[3]*np.sin(cta[0]+cta[1]+cta[2]+cta[3]) ]  ],
                  [ [a[3]*np.cos(cta[0]+cta[1]+cta[2]+cta[3])+a[1]*np.cos(cta[0]+cta[1])+a[0]*np.cos(cta[0])+a[2]*np.cos(cta[0]+cta[1]+cta[2])]   ,  [ a[3]*np.cos(cta[0]+cta[1]+cta[2]+cta[3])+a[1]*np.cos(cta[0]+cta[1])+a[2]*np.sin(cta[0]+cta[1]+cta[2])  ]    ,[a[3]*np.cos(cta[0]+cta[1]+cta[2]+cta[3])+a[2]*np.cos(cta[0]+cta[1]+cta[2]) ] , [ a[3]*np.cos(cta[0]+cta[1]+cta[2]+cta[3]) ]  ],
                  [[1], [1], [1], [1]]
                  ]

    Jacob0 = np.asfarray([[*map(sum, e)]for e in list(Jacob0)], dtype=float)


    #cta = cta + np.dot(np.linalg.pinv(Jacob0),error)
    cta_temp = np.dot(np.linalg.pinv(Jacob0), error)
    cta[0] = cta[0] + cta_temp[0]
    cta[1] = cta[1] + cta_temp[1]
    cta[2] = cta[2] + cta_temp[2]
    cta[3] = cta[3] + cta_temp[3]

    for k in range(1, JOINT_SIZE):
        T[k] = np.dot(T[k - 1], np.asarray(kin.DH(a[k - 1], alpha[k - 1], d[k - 1], cta[k - 1]), dtype=float))

        P[k][0] = T[k][0][3]
        P[k][1] = T[k][1][3]
        P[k][2] = T[k][2][3]
        R[k] = T[k][0:3, 0:3]

b = []
for i in range(len(cta)):
    b.append(cta[i])


cta = np.asarray(b, dtype=float)
print("角度1 = %s" % (theta_1*180/np.pi))
print("角度2 = %s" % (cta[0]*180/np.pi))
print("角度3 = %s" % (cta[1]*180/np.pi))
print("角度4 = %s" % (cta[2]*180/np.pi))
print("角度5 = %s" % (cta[3]*180/np.pi))




