"""傳入琴鍵的座標，將音階標上"""
import cv2
def draw_tone(tone_list,img,xy_old_coordinate):
    img_copy = img.copy()
    for iter in range(len(tone_list)):
            cv2.putText(img_copy, tone_list[iter], (xy_old_coordinate[iter][0], xy_old_coordinate[iter][1]),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.3, (255, 0, 255), 1)
    return img_copy