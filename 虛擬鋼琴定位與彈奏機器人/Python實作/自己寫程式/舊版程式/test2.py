"""正逆運動學測試"""
import kinematics as kin
import phx
import time
import numpy as np
phx.turn_on()

# joint_angles = [0     ,  90 ,0, 0 , 0]
# d0_5 = kin.fk4(joint_angles)
# phx.zero_position()
# print("d0_5=%s#"  % d0_5)
# phx.set_wsew(joint_angles)


# phx.rest_position()
# phx.wait_for_completion()

# xyz_array=[10.8,   3.9,   4.]
# joint_angles = kin.ik5(xyz_array)
# print("joint_angles=%s" % joint_angles)
# phx.set_wsew(joint_angles)
# phx.wait_for_completion()


# xyz_array=[4.1   ,2.9  , 1]
xyz_array=[10   ,-15  , 2.4]
joint_angles = kin.ik5(xyz_array)
print("joint_angles=%s" % joint_angles)
phx.set_wsew(joint_angles)

# import  interpolation_demo
# interpolation_demo.line_demo(5,(15,10))


phx.wait_for_completion()

