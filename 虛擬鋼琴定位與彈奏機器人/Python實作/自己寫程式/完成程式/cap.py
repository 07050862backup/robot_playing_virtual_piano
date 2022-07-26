"""從webcam拍攝影像，並存檔，與專題無相關"""
import cv2
cap = cv2.VideoCapture(1)
while(True):
    # 擷取影像
    ret, ori = cap.read()
    if not ret:
        print("Can't receive frame (stream end?). Exiting ...")
        break
        # 顯示圖片
    cv2.imshow('live', ori)
    # 按下 q 鍵離開迴圈
    if cv2.waitKey(1) == ord('q'):
        break

cv2.imwrite("aruco1.jpg", ori)
cv2.destroyWindow("windows")