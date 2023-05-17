; Chuong trinh hop ngu "Hien thi ra man hinh (duoi dang hh:mm:ss, tai 1 vi tri co dinh) 
; cho den khi co it nhat 2 trong 3 chi so do la nguyen cung nhau va khong co chi so nao la nguyen to hoac 0/1" 
; viet o dang dich ra file .EXE 
; Cach dich trong VSCode: nhay phai chuot chon "Run ASM code"
; Nguoi viet:
; 1. 21120035 - Nguyen Hoai An 
; 2. 21120037 - Ma Thuy Anh
; 3. 21120076 - Nguyen Thanh Hue
;-------------------------------------------------------------------------------------------------------------
.MODEL SMALL
.STACK 100 
.DATA 
    INDEX DB 1D     ; De bat dau vong lap

    NUM_HOUR DB ?   ; De gan gio
    NUM_MIN DB ?    ; De gan phut
    NUM_SEC DB ?    ; De gan giay

    NUM1 DB ? ; Gan so dau tien de kiem tra nguyen to cung nhau
    NUM2 DB ? ; Gan so thu hai de kiem tra nguyen to cung nhau

.CODE
MAIN:
    MOV AX,@DATA  ; Bat dau chuong trinh
    MOV DS,AX

GET_TIME PROC
; Xu ly gio
HOUR:
    MOV AH,2CH    ; Lay thoi gian tu dong ho he thong
    INT 21H       ; Goi ngat
    MOV AL, CH    ; CH = gio (trong khoang tu 0 den 23)
    MOV NUM_HOUR, CH ; NUM_HOUR = CH
    CMP AL, 10   ; So sanh gio voi 10
    JL hour1     ; Neu AL < 10 thi nhay vao hour1
    JE hour2     ; Neu AL = 10 thi nhay vao hour2
    JG hour3     ; Neu AL > 10 thi nhay vao hour3

hour1: ; Neu AL < 10
    MOV AH, 00  ; Gan AH = 0: AH la chu so thu nhat trong chuoi gio
    JMP next    ; Nhay toi next

hour2: ; Neu AL = 10
    MOV AH, 01  ; Gan AH = 1: AH la chu so thu nhat trong chuoi gio
    MOV AL, 00  ; Gan AL = 0: AL la chu so thu hai trong chuoi gio
    JMP next    ; Nhay toi next

hour3: ; Neu AL > 10
    MOV AH, 01  ; Gan AH = 1 : AH la chu so thu nhat trong chuoi gio
    SUB AL, 10  ; Gan AL = AL - 10: AL la chu so thu hai trong chuoi gio
    CMP AL, 10  ; So sanh AL voi 10
    JG hour4    ; Neu AL > 10 nhay vao hour4: Truong hop nay la gio tu 20 -> 23 gio
    JMP next    ; Nhay toi next  

hour4:  ; Khi gio nam trong khoang tu 20 -> 23 gio
    MOV AH, 02  ; Gan AH = 2: AH la chu so thu nhat trong chuoi gio
    SUB AL, 10  ; Gan AL = AL - 10: AL la chu so thu hai trong chuoi gio
    JMP next    ; Nhay toi next   

next: ; Xuat cac ky tu luu gio ra man hinh
    MOV BX,AX     ; Gan BX = AX: trong do AX bao gom AH va AL
    CALL DISP     ; Goi chuong trinh "Hien thi ra man hinh": DISP
    MOV DL,':'    
    MOV AH,02H    ; In ra trong DOS
    INT 21H

; Xu ly phut
MINUTES:
    MOV AH,2CH     ; Lay thoi gian tu dong ho he thong
    INT 21H
    MOV AL,CL      ; CL = phut (trong khoang tu 0 den 59)
    MOV NUM_MIN, CL ; NUM_MIN = CL
    CMP AL, 10     ; So sanh gio voi 10
    JL minute1     ; Neu AL < 10 nhay vao minute1
    JE minute2     ; Neu AL = 10 nhay vao minute2
    JG minute3     ; Neu AL > 10 nhay vao minute3

minute1: ; Neu AL < 10
    MOV AH, 00  ; Gan AH = 0: AH la chu so thu nhat trong chuoi phut
    JMP next1   ; Nhay toi next1 

minute2: ; Neu AL = 10
    MOV AH, 01  ; Gan AH = 1: AH la chu so thu nhat trong chuoi phut
    MOV AL, 00  ; Gan AL = 0: AL la chu so thu hai trong chuoi phut
    JMP next1   ; Nhay toi next1

minute3: ; Neu AL > 10
    MOV AH, 01  ; Gan AH = 1: AH la chu so thu nhat trong chuoi phut
    SUB AL, 10  ; Gan AL = AL - 10: AL la chu so thu hai trong chuoi phut
    CMP AL, 10  ; So sanh AL voi 10
    JE minute0  ; Neu AL = 10 thi AL co the la 20, 30, 40, 50 -> Nhay vao minute0
    JG minute4  ; Neu AL > 10 thi nhay vao minute4
    JMP next1   ; Nhay toi next1

minute4: ;Truong hop AL > 10
    ADD AH, 1   ; Tang AH len 1 
    SUB AL, 10  ; Gan AL = AL - 10: AL la chu so thu hai trong chuoi phut
    CMP AL, 10  ; So sanh AL voi 10
    JE minute0  ; Neu AL = 10 thi AL co the la 20, 30, 40, 50 -> Nhay vao minute0
    JG minute5  ; Neu AL > 10 thi nhay vao minute5
    JMP next1   ; Nhay toi next1

minute5: ;Truong hop AL > 10
    ADD AH, 1   ; Tang AH len 1: AH la chu so thu nhat trong chuoi giay 
    SUB AL, 10  ; Gan AL = AL - 10: AL la chu so thu hai trong chuoi phut
    CMP AL, 10  ; So sanh AL voi 10
    JE minute0  ; Neu AL = 10 thi AL co the la 20, 30, 40, 50 -> Nhay vao minute0
    JG minute4  ; Neu AL > 10 thi nhay vao minute4
    JMP next1   ; Nhay toi next1

minute0: ; Xu ly truong hop phut la 20, 30, 40 hoac 50
    ADD AH, 1  ; Tang AH len 1
    MOV AL, 00 ; Gan AL = 0: AL la chu so thu hai trong chuoi phut 

next1:
    MOV BX,AX   ; Gan BX = AX: trong do AX bao gom AH va AL
    CALL DISP   ; Goi chuong trinh "Hien thi ra man hinh": DISP
    MOV DL,':'  ; In ra trong DOS
    MOV AH,02H
    INT 21H

; Xu ly giay
SECONDS:
    MOV AH,2CH    ; Lay thoi gian tu dong ho he thong
    INT 21H
    MOV AL,DH     ; DH = giay (trong khoang tu 0 den 59)
    MOV NUM_SEC, DH ; NUM_SEC = DH
    CMP AL, 10     ; So sanh AL voi 10
    JL second1     ; Neu AL < 10 thi nhay vao second1
    JE second2     ; Neu AL = 10 thi nhay vao second2
    JG second3     ; Neu AL > 10 thi nhay vao second3

second1: ; Neu AL < 10
    MOV AH, 00  ; Gan AH = 0: AH la chu so thu nhat trong chuoi giay
    JMP next3   ; Nhay toi next3

second2: ; Neu AL = 10
    MOV AH, 01  ; Gan AH = 1: AH la chu so thu nhat trong chuoi giay
    MOV AL, 00  ; Gan AL = 0: AL la chu so thu hai trong chuoi giay
    JMP next3   ; Nhay toi next3

second3: ; Neu AL > 10
    MOV AH, 01  ; Gan AH = 1: AH la chu so thu nhat trong chuoi giay
    SUB AL, 10  ; Gan AL = AL - 10: AL la chu so thu hay trong chuoi giay
    CMP AL, 10  ; So sanh AL voi 10
    JE second0  ; Neu AL = 10 thi AL co the la 20, 30, 40, 50 -> Nhay vao second0
    JG second4  ; Neu AL > 10 thi nhay vao second4
    JMP next3   ; Nhay toi next3

second4:
    ADD AH, 1   ; Tang AH len 1: AH la chu so thu nhat trong chuoi giay  
    SUB AL, 10  ; Gan AL = AL - 10: AL la chu so thu hai trong chuoi giay
    CMP AL, 10  ; So sanh AL voi 10
    JE second0  ; Neu AL = 10 thi AL co the la 20, 30, 40, 50 -> Nhay vao second0
    JG second5  ; Neu AL > 10 thi nhay vao second5
    JMP next3   ; Nhay toi next3 

second5:
    ADD AH, 1   ; Tang AH len 1: AH la chu so thu nhat trong chuoi giay  
    SUB AL, 10  ; Gan AL = AL - 10: AL la chu so thu hai trong chuoi giay
    CMP AL, 10  ; So sanh AL voi 10  
    JE second0  ; Neu AL = 10 thi AL co the la 20, 30, 40, 50 -> Nhay vao second0
    JG second4  ; Neu AL > 10 thi nhay vao second4
    JMP next3   ; Nhay toi next3         

second0: ; Xu ly truong hop giay la 20, 30, 40 hoac 50
    ADD AH, 1   ; Tang AH len 1 
    MOV AL, 00  ; Gan AL = 0: AL la chu so thu hai trong chuoi giay  

next3:
    MOV BX,AX   ; Gan BX = AX: trong do AX bao gom AH va AL
    CALL DISP   ; Goi chuong trinh "Hien thi ra man hinh": DISP

; Ngat dong
MOV AH,2
MOV DL,0AH
INT 21H
GET_TIME ENDP

MOV AL,NUM_HOUR     ; Gan gio vao AL de kiem tra gio co hop le hay khong
CALL CHECK_VALID    ; Kiem tra xem gio co hop le hay khong roi lua vao CL
CMP CL, 1           ; So sanh CL = 1 -> hop le,  nguoc lai -> ko hop le
JNE LOOP_TIME 

MOV AL, NUM_MIN     ; Gan phut vao AL de kiem tra phut co hop le hay khong
CALL CHECK_VALID    ; Kiem tra xem phut co hop le hay khong
CMP CL, 1           ; So sanh CL = 1 -> hop le,  nguoc lai -> ko hop le
JNE LOOP_TIME

MOV AL, NUM_SEC     ; Gan giay vao AL de kiem tra giay co hop le hay khong
CALL CHECK_VALID    ; Kiem tra xem giay co hop le hay khong
CMP CL, 1           ; So sanh CL = 1 -> hop le,  nguoc lai -> ko hop le
JNE LOOP_TIME

CALL ASSIGN 
MOV NUM1, CL   ; Gan NUM1 = phut
MOV NUM2, DH   ; Gan NUM2 = giay
CALL COPRIME   ; Kiem tra nguyen to S nhau giua PHUT va GIAY
CMP CL, 1      ; CL = 1 -> nguyen to cung nhau, nguoc lai -> khong nguyen to cung nhau
JE EXIT
CALL ASSIGN
MOV NUM1, CH   ; Gan NUM1 = gio
MOV NUM2, DH   ; Gan NUM2 = giay
CALL COPRIME   ; Kiem tra nguyen to cung nhau giua GIO va GIAY
CMP CL, 1      ; CL = 1 -> nguyen to cung nhau, nguoc lai -> khong nguyen to cung nhau
JE EXIT
CALL ASSIGN
MOV NUM1, CH   ; Gan NUM1 = gio
MOV NUM2, CL   ; Gan NUM2 = phut
CALL COPRIME   ; Kiem tra nguyen to cung nhau giua GIO va PHUT
CMP CL, 1      ; CL = 1 -> nguyen to cung nhau, nguoc lai -> khong nguyen to cung nhau
JE EXIT
JNE LOOP_TIME

ASSIGN PROC    ; ham gan lai gio, phut, giay vao cac thanh ghi
    MOV CH, NUM_HOUR    ;CH = GIO
    MOV CL, NUM_MIN     ;CL = PHUT
    MOV DH, NUM_SEC     ;DH = GIAY
    RET
ASSIGN ENDP

EXIT: ; Ket thuc chuong trinh
    MOV AH,4CH    
    INT 21H

LOOP_TIME PROC ; Goi lai ham lay thoi gian
   CALL GET_TIME
   INT 21H
   RET            ; return: de ket thuc chuong trinh con
LOOP_TIME ENDP    ; Ket thuc ham con LOOP_TIME 

DISP PROC     ; Ham in thoi gian ra man hinh - Tham khao: https://gist.github.com/Suman2593/8c4ecff6f37b811fc1f89b043b0f5e92?fbclid=IwAR05iq5j1C5QBoDm75KV7xnP75_KEqpWuKFt8vAZCOMK_8dUU-_8zeAvNug
    MOV DL,BH      ; Vi gia tri BH la mot phan nam trong BX
    ADD DL,30H     ; Doi sang ma ASCII
    MOV AH,02H     ; In trong DOS
    INT 21H
    MOV DL,BL      ; Vi gia tri BL la mot phan nam trong BX
    ADD DL,30H     ; Doi sang ma ASCII
    MOV AH,02H     ; In trong DOS
    INT 21H
    RET            ; return: de ket thuc chuong trinh con
DISP ENDP          ; Ket thuc ham con Disp 

CHECK_VALID PROC  ; Ham kiem tra tinh hop le cua gio, phut, giay (kiem tra xem bien AL co la so nguyen to hay 0/1)
    MOV DL, INDEX

    CMP AL, 0 ; So sanh so do co bang 0 hay khong
    JE INVALID  ; Neu bang 0 tra ve khong hop le
    JNE CHECK_1 ; Neu khac 0 thi so sanh voi 1

CHECK_1: ; Kiem tra so do bang 1 hay khong
    CMP AL, 1 ; So sanh so do co bang 1 hay khong
    JE INVALID  ; Neu bang 1 tra ve khong hop le
    JNE CHECK_2 ; Neu khac 1 thi so sanh voi 2

CHECK_2: ; Kiem tra so do co bang 2 hay khong
    CMP AL, 2   ; So sanh so do co bang 2 hay khong
    JE INVALID  ; Neu bang 2 tra ve khong hop le
    JNE CHECK_PRIME ; Neu khac 2 thi kiem tra co phai so nguyen to hay khong

CHECK_PRIME: ; Kiem tra so co phai la so nguyen to hay khong
    ADD DL, 1   ; Tao vong lap bat dau tu INDEX = 2 roi tang 1 don vi sau moi vong lap den khi bang so can kiem tra
    MOV INDEX, DL 
    MOV BL, AL  ; Gan BL = AL de giu lai gia tri ban dau cua AL so can kiem tra
    CMP AL, INDEX  ; So sanh AL voi bien INDEX
    JE INVALID     ; Neu AL = INDEX tra ve khong hop le
    JNG CHECK_SAME_PRIME     ; Neu AL > INDEX : kiem tra AL va INDEX co nguyen to cung hay hay khong

CHECK_SAME_PRIME:  ; Kiem tra BL (da gan BL = AL) va INDEX co nguyen to cung hay hay khong
    CMP BL, INDEX   ; So sanh BL va INDEX
    JE CHECK_PRIME  ; Neu BL = INDEX -> quay lai CHECK_PRIME de kiem tra voi so INDEX tiep theo
    JL CASE_1       ; Neu BL < INDEX, nhay vao CASE_1
    JG CASE_2       ; Neu BL > INDEX, nhay vao CASE_2

CASE_1: ; Truong hop BL < INDEX, gan INDEX = INDEX - BL
    SUB INDEX,BL

    CMP INDEX, 1    ; So sanh INDEX voi 1
    JE CHECK_PRIME  ; Neu INDEX = 1 thi BL va INDEX nguyen to cung nhau -> quay lai CHECK_PRIME de kiem tra voi so INDEX tiep theo

    CMP INDEX, BL ;Neu khong thi thiep tuc so sanh INDEX va BL
    JE VALID    ; Neu INDEX = BL -> tra ve hop le
    JL CASE_2   ; Neu INDEX < BL , nhay vao CASE_2
    JG CASE_1   ; Neu INDEX > BL , nhay vao CASE_1

CASE_2: ; Truong hop BL > INDEX, gan BL = BL - INDEX
    SUB BL,INDEX

    CMP BL, 1 ; So sanh BL voi 1
    JE CHECK_PRIME ; Neu BL= 1 thi BL va INDEX nguyen to cung nhau -> quay lai CHECK_PRIME de kiem tra voi so INDEX tiep theo

    CMP BL, INDEX  ; Neu khong thi thiep tuc so sanh INDEX va BL
    JE VALID    ; Neu BL = INDEX -> tra ve hop le
    JL CASE_1   ; Neu BL < INDEX , nhay vao CASE_1
    JG CASE_2   ; Neu BL > INDEX , nhay vao CASE_2

INVALID:  ; Neu so do khong hop le
    MOV CL, 0  ; Gan CL = 0
    RET

VALID:  ; Neu so do hop le
    MOV CL, 1 ; Gan CL = 1
    RET

CHECK_VALID ENDP

COPRIME PROC ; Ham kiem tra 2 so co nguyen to cung nhau hay khong
    MOV BL, NUM2  ; Gan so thu 2 vao BL
 
    CMP NUM1, BL  ; So sanh so thu nhat voi so thu hai
    JL LABLE2     ; NUM1 < NUM2: nhay vao LABLE2
    JE NO_COPRIME ; NUM1 = NUM2: tra ve khong nguyen to cung nhau
    JG LABLE3     ; NUM1 > NUM2: nhay vao LABLE3

LABLE2: ;Truong hop NUM1 < NUM2, thi gan NUM2 = NUM2 - NUM1
    SUB BL,NUM1

    CMP BL,1   ; So sanh NUM2 voi 1
    JE HAVE_COPRIME  ; Neu NUM2 = 1 -> nguyen to cung nhau

    CMP BL,NUM1 ; Neu khong, tiep tuc so sanh NUM2 voi NUM1
    JE NO_COPRIME   ; NUM2 = NUM1 -> khong nguyen to cung nhau 
    JL LABLE3       ; Neu NUM2 < NUM1: tiep tuc nhay vao LABLE3
    JG LABLE2       ; Neu NUM2 > NUM1: tiep tuc nhay vao LABLE2

LABLE3: ;Truong hop NUM1 > NUM2, thi gan NUM1 = NUM1 - NUM2
    SUB NUM1,BL

    CMP NUM1,1  ; So sanh NUM1 voi 1
    JE HAVE_COPRIME  ; Neu NUM1 = 1 -> nguyen to cung nhau

    CMP NUM1,BL ; Neu khong, tiep tuc so sanh NUM1 voi NUM2
    JE NO_COPRIME   ; NUM1 = NUM2 -> khong nguyen to cung nhau 
    JL LABLE2       ; Neu NUM1 < NUM2: tiep tuc nhay vao LABLE3
    JG LABLE3       ; Neu NUM1 > NUM2: tiep tuc nhay vao LABLE2

HAVE_COPRIME: ; Neu 2 so nguyen to cung nhau
    MOV CL, 1 ; Thi gan CL = 1
    RET

NO_COPRIME: ; Neu 2 so khong nguyen to cung nhau
    MOV CL, 0 ; Thi gan CL = 0
    RET

COPRIME ENDP

END MAIN
