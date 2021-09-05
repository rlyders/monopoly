10 Rem @@@@@@@@@@ (N=N+1)====[N=N MOD RANGE+1]
20 Rem $STATIC
30 Rem ON A GOTO 1740,2380,3050,3150 'HAVE ERASE/REDIM/DIM STATEMENTS
40 Clear: Screen 0, , 0, 0: Color , 0: Cls: Width 80: Randomize Timer: Locate , , 0: KEY Off: Def Seg = 64
If (Peek(16) And &H30) = &H30 Then COLOR_ZZ = 7 Else COLOR_ZZ = 8
50 Def Seg = 0
CARDS_PER_TYPE = 16
60 Dim J(4), PROPERTY_SHORT_NAMES$(40), PROPERTY_COST(40), PROPERTY_FOREGROUND_COLOR(40), PROPERTY_BACKGROUND_COLOR(40), PROPERTY_OWNER(40), PROPERTY_TYPE(40), G(10, 4), PROPERTY_GROUP_NUM(40), RENT_RATES(6, 40), L$(4), L(4), PLAYER_CURRENT_PROPERTY(4), X(2, 4), Y(4), B(4, 11), PROPERTY_HOUSES(40), PP(4, 28), PLAYER_P(4), PROPERTY_M(40), CHANCE_CARDS(CARDS_PER_TYPE), COMMUNITY_CHEST_CARDS(CARDS_PER_TYPE), PROPERTY_BOARD_NUM(40), PM(40), PLAYER_CASH(4), BH(4), V(4), H(4), PLAYER_COLOR(4), PROPERTY_NAMES$(40), FJ(4), I(4), CH$(32), RTP(4), PD(40)
70 Dim CM(40), CU(40), CI(40), CW(40), CO(40), KR(240), C3(11), TP(4), BV(4), PPN(40), CC3(4), CCR(4), GN$(60), KY$(11), HB(10), O$(8), OO$(8), OO(8), OCCR(4), OCC3(4), CARD$(2, CARDS_PER_TYPE, 7), PLAYER_MAP(4), PLAYER_UNMAP(4), PLAYER_XN(4), J$(4)

Rem Load data file: property, cards, etc
80 Open "I", #1, "M.DF"

Rem Load 41 properties (Go is loaded twice (first and last) for some reason)
For P = 0 To 40
    Rem Load property name, abbreviation, foreground color, background color, group num (property group#), kind (board space type), board num (side# of board) (1-4 or 0 - why 0?), cost
    Input #1, PROPERTY_NAMES$(P), PROPERTY_SHORT_NAMES$(P), PROPERTY_FOREGROUND_COLOR(P), PROPERTY_BACKGROUND_COLOR(P), PROPERTY_GROUP_NUM(P), PROPERTY_TYPE(P), PROPERTY_BOARD_NUM(P), PROPERTY_COST(P)
Next

Rem Load 6 rent rates x 41 properties
90 For A = O To 5
    For P = 0 To 40
        Input #1, RENT_RATES(A, P)
Next P, A

Rem Load 11 ? x 4 ?s
For G = 0 To 10
    For P = 1 To 4
        Input #1, G(G, P), B(P, G)
Next P, G

Rem Load 240 out of 256 character #s (why?)
For A = 1 To 240
    Input #1, KR(A)
Next A

Rem Load 2 card types (chance and community chest) x 16 cards x # of text lines
100 For A = 1 To 2
    For B = 1 To CARDS_PER_TYPE
        Input #1, CARD$(A, B, 0)
        110 For C = 1 To Val(CARD$(A, B, 0))
            Input #1, CARD$(A, B, C)
Next C, B, A
Close #1

120 PLAYY = 0: SOUNDS = 1: AUTOKYBD = 0: CURRENT_PROPERTY_NUM = 0: CL = 1: PLAYER_PL = 1: E = 0: T = 0: FM = 1
MAX_PLAYERS = 4
NUM_OF_PLAYERS = MAX_PLAYERS
GoSub 8570
130 LB = 0: C# = 0
For C3 = 2 To 15
    If C3 = 3 Or C3 = 6 Or C3 = 7 Or C3 = 8 Or C3 = 14 Or C3 = 15 Then
        _Continue
    Else
        C# = C# + 1
        C3(C#) = C3
    End If
Next C3

For L = 1 To MAX_PLAYERS
    PLAYER_MAP(L) = L
    PLAYER_UNMAP(L) = L
Next L
150 KK = 8

For L = 1 To MAX_PLAYERS
    CCR(PLAYER_MAP(L)) = PLAYER_MAP(L)
    OCCR(PLAYER_MAP(L)) = PLAYER_MAP(L)
    L(PLAYER_MAP(L)) = KR(PLAYER_MAP(L))
    CC3(PLAYER_MAP(L)) = PLAYER_MAP(L)
    OCC3(PLAYER_MAP(L)) = PLAYER_MAP(L)
    PLAYER_COLOR(PLAYER_MAP(L)) = C3(PLAYER_MAP(L))
    BV(PLAYER_MAP(L)) = 11
    TP(PLAYER_MAP(L)) = 0
    RTP(PLAYER_MAP(L)) = 0
    PLAYER_CURRENT_PROPERTY(PLAYER_MAP(L)) = 0
    X(1, PLAYER_MAP(L)) = R1 - KK + PLAYER_MAP(L)
    X(2, PLAYER_MAP(L)) = L1 + KK - PLAYER_MAP(L)
    Y(PLAYER_MAP(L)) = T1 + 4
    PLAYER_CASH(PLAYER_MAP(L)) = 1500
    151 J$(L) = "Player" + Right$(Str$(L), 1)
Next L

PAUSE_SECS = 3
WH = 9
160 CGN$ = ""
L = 1
B = 0
Randomize Timer
For A = 1 To CARDS_PER_TYPE
    CHANCE_CARDS(A) = A
    COMMUNITY_CHEST_CARDS(A) = A
Next A
For A = 1 To CARDS_PER_TYPE
    Swap CHANCE_CARDS(A), CHANCE_CARDS(Int(Rnd * CARDS_PER_TYPE + 1))
    Swap COMMUNITY_CHEST_CARDS(A), COMMUNITY_CHEST_CARDS(Int(Rnd * CARDS_PER_TYPE + 1))
Next A
GoSub 750
GoTo 900

170 Rem
180 Rem chrs/colors
190 Rem
200 Screen 0, , 1, 0: Color 0, 0: Cls: Screen 0, , 1, 1
210 WDTH = 80 / C#: V = 11: H = 2: EH = H + C# * WDTH: BH = H
220 H = 1
For C3 = 1 To C#
    Locate V - 1, H + 4
    Color COLOR_ZZ, 0
    Print C3
    Locate V, H
    Color C3(C3), 0
    Print String$(WDTH, Chr$(219));
    H = H + WDTH
Next C3
Color COLOR_ZZ, 0: H = 2: BH = H: EH = 79: V = 13: BV = V: EV = V + 10
230 Locate BV, BH
For CR = 1 To 6
    Print Chr$(CR); " ";
Next CR
Print Chr$(8)
H = 16
240 For CR = 14 To 27
    Locate V, H
    Print Chr$(CR);
    H = H + 2
Next CR

250 Locate BV, BH + 42: Print "! "; Chr$(34); " # $ % & ' ( ) * + , - . / 0 1 2 3"
260 Locate BV + 2, BH: Print "4 5 6 7 8 9 : ; < = > ? @ A B C D E F G H I J K L M N O P Q R S T U V W X Y Z ["
270 Locate BV + 4, BH: Print "\ ] ^ _ ` a b c d e f g h i j k l m n o p q r s t u v w x y z { | } ~  Ä Å Ç É"
280 Locate BV + 6, BH: Print "Ñ Ö Ü á à â ä ã å ç é è ê ë í ì î ï ñ ó ò ô ö õ ú ù û ü † ° ¢ £ § • ¶ ß ® © ™ ´"
290 Locate BV + 8, BH: Print "¨ ≠ Æ Ø ∞ ± ≤ ¥ µ ∂ ∑ ∏ π ∫ ª º Ω æ ø ¿ ¡ ¬ √ ƒ ≈ ∆ « » …   À Ã Õ Œ œ – — “ ” ‘"
300 Locate BV + 10, BH: Print "’ ÷ ◊ ÿ Ÿ ⁄ € ‹ › ‡ · ‚ „ ‰ Â Ê Á Ë È Í Î Ï Ì Ó Ô  Ò Ú Û Ù ı ˆ ˜ ¯ ˘ ˙ ˚ ¸ ˝ ˛";
310 H = 2: BH = H: EH = BH + 78: V = 13: BV = V: EV = V + 10

320 For L = 1 To MAX_PLAYERS
    CC3(PLAYER_MAP(L)) = OCC3(PLAYER_MAP(L))
    CCR(PLAYER_MAP(L)) = OCCR(PLAYER_MAP(L))
Next L

330 For L = 1 To MAX_PLAYERS
    H(PLAYER_MAP(L)) = BH + (CCR(PLAYER_MAP(L)) - (Int(CCR(PLAYER_MAP(L)) / 40) * 40) - 1) * 2
    V(PLAYER_MAP(L)) = BV + Int(CCR(PLAYER_MAP(L)) / 40) * 2
Next L

340 For L = 1 To NUM_OF_PLAYERS
    Locate V(PLAYER_MAP(L)), H(PLAYER_MAP(L))
    Color C3(CC3(PLAYER_MAP(L))), 0
    Print Chr$(KR(CCR(PLAYER_MAP(L))))
Next L
350 Poke 1050, Peek(1052): L = 1: Y1 = 7: X1 = 40: COLOR_CC = COLOR_ZZ: X1 = 28
360 Rem
370 Rem *** menu ***
380 X1 = (80 - MAX_PLAYERS * NUM_OF_PLAYERS) / 2
390 Locate Y1, 1: Color COLOR_ZZ, 0: Print Space$(X1) + " [ ";
400 For A = 1 To NUM_OF_PLAYERS - 1: Color C3(CC3(PLAYER_MAP(A))), 0: Print Chr$(KR(CCR(PLAYER_MAP(A))));: Color COLOR_ZZ, 0: Print " | ";: Next A
410 Color C3(CC3(PLAYER_MAP(NUM_OF_PLAYERS))), 0: Print Chr$(KR(CCR(PLAYER_MAP(NUM_OF_PLAYERS))));: Color COLOR_ZZ, 0: Print " ]" + Space$((80 - MAX_PLAYERS * NUM_OF_PLAYERS - X1) / 2)
420 GoTo 480
430 Locate Y1 - 1, X1 + 4 * LCL - 1: Print Chr$(218); Chr$(196); Chr$(191);
440 Locate Y1, X1 + 4 * LCL + 1: Print Chr$(179);
450 Locate Y1, X1 + 4 * LCL - 1: Print Chr$(179);
460 Locate Y1 + 1, X1 + 4 * LCL - 1: Print Chr$(192); Chr$(196); Chr$(217);
470 Return
480 Color 0, 0: GoSub 430: Color 14, 0: LCL = L: GoSub 430
490 Color C3(CC3(PLAYER_MAP(L))), 0: Locate V(PLAYER_MAP(L)), H(PLAYER_MAP(L)): Print Chr$(KR(CCR(PLAYER_MAP(L))));: Locate Y1, X1 + 4 * L: Print Chr$(KR(CCR(PLAYER_MAP(L))));
500 KEY_PRESSED$ = InKey$
On Len(KEY_PRESSED$) + 1 GOTO 500, 510, 570
510 If KEY_PRESSED$ = Chr$(13) Then For F = 1 To MAX_PLAYERS: OCC3(PLAYER_MAP(F)) = CC3(PLAYER_MAP(F)): OCCR(PLAYER_MAP(F)) = CCR(PLAYER_MAP(F)): Next F: AA = 1: GoTo 720
520 If KEY_PRESSED$ = Chr$(27) Then For F = 1 To MAX_PLAYERS: CC3(PLAYER_MAP(F)) = OCC3(PLAYER_MAP(F)): CCR(PLAYER_MAP(F)) = OCCR(PLAYER_MAP(F)): Next F: AA = 0: GoTo 730
530 GoTo 540
540 If Val(KEY_PRESSED$) > C# Or Val(KEY_PRESSED$) = 0 Then
    GoTo 560
Else
    For A = 1 To NUM_OF_PLAYERS
        If Val(KEY_PRESSED$) = CC3(PLAYER_MAP(A)) Then CHCK = 1
    Next A

    If CHCK Then
        CHCK = 0
        GoTo 490
    Else
        CC3(PLAYER_MAP(L)) = Val(KEY_PRESSED$)
        GoTo 490
    End If
End If

560 If KEY_PRESSED$ = Chr$(9) Then LL = L: L = L + 1: GoTo 580 Else GoTo 500
570 KEY_PRESSED$ = Right$(KEY_PRESSED$, 1): If KEY_PRESSED$ = Chr$(15) Then LL = L: L = L - 1 Else GoTo 600
580 If L > NUM_OF_PLAYERS Then L = 1 Else If L < 1 Then L = NUM_OF_PLAYERS
590 GoTo 480
600 If KEY_PRESSED$ = Chr$(77) Then VV = 0: HV = 2: CV = 1: GoTo 640
610 If KEY_PRESSED$ = Chr$(75) Then VV = 0: HV = -2: CV = -1: GoTo 640
620 If KEY_PRESSED$ = Chr$(72) Then HV = 0: VV = -2: CV = -40: GoTo 640
630 If KEY_PRESSED$ = Chr$(80) Then HV = 0: VV = 2: CV = 40 Else GoTo 500
640 Color COLOR_ZZ, 0: Locate V(PLAYER_MAP(L)), H(PLAYER_MAP(L)): Print Chr$(KR(CCR(PLAYER_MAP(L))));
650 CCR(PLAYER_MAP(L)) = CCR(PLAYER_MAP(L)) + CV: V(PLAYER_MAP(L)) = V(PLAYER_MAP(L)) + VV: H(PLAYER_MAP(L)) = H(PLAYER_MAP(L)) + HV
660 If H(PLAYER_MAP(L)) < BH Then H(PLAYER_MAP(L)) = EH: CCR(PLAYER_MAP(L)) = CCR(PLAYER_MAP(L)) + 40: GoTo 700
670 If H(PLAYER_MAP(L)) > EH Then H(PLAYER_MAP(L)) = BH: CCR(PLAYER_MAP(L)) = CCR(PLAYER_MAP(L)) - 40: GoTo 700
680 If V(PLAYER_MAP(L)) > EV Then V(PLAYER_MAP(L)) = BV: CCR(PLAYER_MAP(L)) = CCR(PLAYER_MAP(L)) - 240: GoTo 700
690 If V(PLAYER_MAP(L)) < BV Then V(PLAYER_MAP(L)) = EV: CCR(PLAYER_MAP(L)) = CCR(PLAYER_MAP(L)) + 240
700 For A = 1 To NUM_OF_PLAYERS: If CCR(A) = CCR(PLAYER_MAP(L)) And L <> A Then CHECK = 1
710 Next A: If CHECK Then CHECK = 0: GoTo 650 Else GoTo 490
720 For L = 1 To NUM_OF_PLAYERS: L(PLAYER_MAP(L)) = KR(CCR(PLAYER_MAP(L))): PLAYER_COLOR(PLAYER_MAP(L)) = C3(CC3(PLAYER_MAP(L))): Next L
730 If AA = 1 Then Cls: Screen 0, , 0, 1: Color 0, 0: Cls
740 Screen 0, , 0, 0: Return
750 Poke 1050, Peek(1052): Color COLOR_ZZ, 0: Locate , , 0, 7, 0: Cls: Locate T1, L1: Print "«ƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒ¬ƒƒƒƒƒ¬ƒƒƒƒƒ¬ƒƒƒƒƒ¬ƒƒƒƒƒ¬ƒƒƒƒƒ¬ƒƒƒƒƒ¬ƒƒƒƒƒ¬ƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒ∂"
760 Locate T1 + 1, L1: Print "∫         ≥     ≥     ≥     ≥     ≥     ≥     ≥     ≥     ≥     ≥         ∫"
770 Locate T1 + 2, L1: Print "∫         ≥     ≥     ≥     ≥     ≥     ≥     ≥     ≥     ≥     ≥         ∫"
780 Locate T1 + 3, L1: Print "∫         ≥     ≥     ≥     ≥     ≥";: Color 7: Print " è‹€";: Color COLOR_ZZ: Print " ≥     ≥     ≥     ≥     ≥         ∫"
790 Locate T1 + 4, L1: Print "∫         ≥     ≥     ≥     ≥     ≥";: Color 7: Print " ¯ ¯";: Color COLOR_ZZ: Print " ≥     ≥     ≥     ≥     ≥         ∫"
800 Locate T1 + 5, L1: Print "»ÕÕÕÕÕÕÕÕÕœÕÕÕÕÕœÕÕÕÕÕœÕÕÕÕÕœÕÕÕÕÕœÕÕÕÕÕœÕÕÕÕÕœÕÕÕÕÕœÕÕÕÕÕœÕÕÕÕÕœÕÕÕÕÕÕÕÕÕº": Color COLOR_ZZ, 0: GoSub 8570
810 GoSub 11530: GoSub 11610: GoSub 11570
820 Locate T2, L2: Print "…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª"
830 For A = 1 To 16: Locate T2 + A, L2: Print "∫";: Locate , R2: Print "∫";: Next A
840 Locate B2, L2: Print "»ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº";
850 For L = 1 To NUM_OF_PLAYERS: Color PLAYER_COLOR(PLAYER_MAP(L)), 0: Locate T6, BH(L) - 1: Print "…ÕÕÕÕÕÕÕÕÕª"
    860 For V = T6 + 1 To BV(L) + W# - 1: Locate V, BH(L) - 1: Print "∫";: Locate V, BH(L) + W6: Print "∫";: Next V
    870 GoSub 1510 'LOCATE T6+2,BH(L)-1:PRINT CHR$(199);STRING$(9,196);CHR$(182)
880 Locate BV(L) + W#, BH(L) - 1: Print "»ÕÕÕÕÕÕÕÕÕº";: Next L: Return
890 Rem
900 Rem   @@@@@@@@ MONOPOLY @@@@@@@@@@
910 Rem
920 For L = 1 To NUM_OF_PLAYERS: H(PLAYER_MAP(L)) = BH(PLAYER_MAP(L)): GoSub 7240: GoSub 1390: GoSub 1540: Next L: GoSub 1870
930 KEY_PRESSED$ = InKey$: If Len(KEY_PRESSED$) And SG = 0 Then 940 Else If SG Then 950 Else GoTo 960
940 For P = 1 To 39: PROPERTY_OWNER(P) = Int((Rnd * NUM_OF_PLAYERS + 1) * Abs(PROPERTY_TYPE(P) > 1)): Next P
950 For L = 1 To NUM_OF_PLAYERS: GoSub 1540: GoSub 1600: GoSub 1710: Next L
960 Rem
970 Rem @@@@ DRAW BOARDS @@@@
980 Rem
990 If CB Then If BW_FLAG Then SB = PROPERTY_BOARD_NUM(PO) - 1: GoTo 1010 Else SB = PROPERTY_BOARD_NUM(PO): GoTo 1010
1000 GoSub 12020: SB = PROPERTY_BOARD_NUM(CURRENT_PROPERTY_NUM)
1010 GoSub 1020: GoTo 1260
1020 If SB = LB And SG = 0 Then Return
1030 BX = R1 - 9: BXX = R1 - 9: BB = B(SB, 0): If LB <> SB Then GoSub 1230
1040 GoSub 1060: GoSub 1150: BXX = L1 + 1: BX = L1 + 2: BB = B(SB, 10): GoSub 1060: GoSub 1240
1050 LB = SB: Return
1060 If BB <> 10 Then Color COLOR_ZZ, 0: Locate T1, BX + 1: Print String$(6, 196): Locate T1 + 1, BX + 1: Print Space$(6)
1070 On BB / 10 + 1 GOTO 1080, 1090, 1110, 1120
1080 Color 4, 0: Locate T1 + 2, BXX: Print "         ": Locate T1 + 3, BXX: Print "   "; Chr$(27); "GO   ": GoTo 1130
1090 Color COLOR_ZZ, 0: Locate T1, BX + 1: Print Chr$(194) + String$(4, 196) + Chr$(194): Locate T1 + 1, BX + 1: Print Chr$(179): Locate T1 + 1, BX + 6: Print Chr$(179): Locate T1 + 2, BX + 1: Print Chr$(192) + String$(4, 196) + Chr$(217)
1100 Color 6, 0: Locate T1 + 3, BX: Print "  JAIL  ": GoTo 1130
1110 Color 4, 0: Locate T1 + 2, BXX: Print "  FREE   ": Locate T1 + 3, BXX: Print " PARKING ": GoTo 1130
1120 Color 11, 0: Locate T1 + 2, BXX: Print "  GO TO  ": Locate T1 + 3, BXX: Print "  JAIL   ": GoTo 1130
1130 Return
1140 Rem show properties
1150 BF = 5: For P = 1 To 9: BX = R1 - 15 - 6 * (P - 1): BP = B(SB, P)
    1160 Color 0, 0: If PROPERTY_TYPE(B(SB, P)) = 1 Or PROPERTY_GROUP_NUM(BP) = 10 Then Locate T1 + 1, BX: Print "     ": Locate T1 + 3, BX: GoTo 1180 Else If PROPERTY_GROUP_NUM(BP) <> 9 Then Locate T1 + 3, BX: Print "     "
    1170 Locate T1 + 1, BX
    1180 If PROPERTY_GROUP_NUM(BP) <> 10 Then GoSub 10880 Else Color COLOR_ZZ - PROPERTY_M(BP), 0: Print " "; PROPERTY_SHORT_NAMES$(BP); " ";
    1190 Rem
    1200 Color 2: Locate T1 + 2, (B(SB, 10) - BP - 1) * 6 + 11 + L1
    1210 CU(BP) = PROPERTY_HOUSES(BP): GoSub 11050
1220 Next P: Return
1230 EB = 1: CAB = LB: For CA = 1 To NUM_OF_PLAYERS: GoSub 8520: Next CA: EB = 0: Return
1240 For CA = 1 To NUM_OF_PLAYERS: If CA <> G2 And (BW_FLAG = 0 Or CA <> CL Or FM) Then GoSub 8510
1250 Next CA: Return
1260 Rem
1270 If SG Then SG = 0: If PLAYER_OWES_MONEY_STATUS Then FM = 0: GoTo 11440
1280 If CB Then 4680
1290 If GO2 Then P1 = CURRENT_PROPERTY_NUM: GoTo 4860
1300 GoSub 11570: GoSub 11530
If DOUBLES_IN_ROW_COUNT Then 1360

1310 Rem
1320 Rem @@@@ CLEAR/SET ROUND VARIABLES @@@@
1330 Rem
1340 If FM = 0 Then CL = CL + 1: If CL > NUM_OF_PLAYERS Then CL = 1 Else If CL < 1 Then CL = NUM_OF_PLAYERS
1350 DOUBLES_IN_ROW_COUNT = 0: PLAYY = 0
1360 FM = 0: CURRENT_PROPERTY_NUM = PLAYER_CURRENT_PROPERTY(PLAYER_MAP(CL)): PO = CURRENT_PROPERTY_NUM: LP = CURRENT_PROPERTY_NUM
1370 Y = Y(PLAYER_MAP(CL)): NY = Y: X = X(1, PLAYER_MAP(CL)): LX = X: For L = 1 To NUM_OF_PLAYERS: H(PLAYER_MAP(L)) = BH(PLAYER_MAP(L)): Next L: RR = 0: R = 0
1380 GoSub 1860: GoTo 1930

1390 Rem
1400 Rem @@@@ SHOW PLAYER'S WEALTH @@@@
1410 Rem
1420 Color PLAYER_COLOR(PLAYER_MAP(L)), 0
1430 If PLAYER_CASH(PLAYER_MAP(L)) < 1000000! Then Locate BV(L) - 2, BH(L): Print Using "$$#####,"; PLAYER_CASH(PLAYER_MAP(L)) Else Locate BV(L) - 2, BH(L): Print Using "$$#######"; PLAYER_CASH(PLAYER_MAP(L))
1440 Return

1450 Rem
1460 Rem @@@@ SHOW PLAYER'S EXCHANGE @@@@
1470 Rem
1480 Color 14, 1: If PLAYER_EXCHANGE < 100000! Then Locate BV(L) - 1, BH(L): Print Using "+$$####,"; PLAYER_EXCHANGE;: Print " " Else Locate BV(L) - 1, BH(L): Print Using "+$$#####,"; PLAYER_EXCHANGE
1490 Return

1500 Rem
1510 Rem @@@@ UNDO PLAYER'S EXCHANGE @@@@
1520 Rem
1521 Locate BV(L) - 1, BH(L) - 1: Color PLAYER_COLOR(PLAYER_MAP(L)), 0: PSS = Int(1 / 2 * WH - 1 / 2 * Len(J$(PLAYER_MAP(L))))
1522 Print "«" + String$(PSS, Chr$(196)) + J$(PLAYER_MAP(L));
1523 PSS = BH(L) + WH - Pos(0): Print String$(PSS, Chr$(196)) + "∂": Return
1530 Color PLAYER_COLOR(PLAYER_MAP(L)), 0: Locate BV(L) - 1, BH(L) - 1: Print "«ƒƒƒƒƒƒƒƒƒ∂": Return

1540 Rem
1550 Rem @@@@ SHOW Bail CARDS @@@@
1560 Rem
1570 Locate BV(L) + W#, BH(L): If J1 = PLAYER_MAP(L) Then Color 0, 6: Print "Bail"; Else Color PLAYER_COLOR(PLAYER_MAP(L)), 0: Print "ÕÕÕÕ";
1580 Locate BV(L) + W#, BH(L) + WH - 4: If J2 = PLAYER_MAP(L) Then Color 0, 3: Print "Bail"; Else Color PLAYER_COLOR(PLAYER_MAP(L)), 0: Print "ÕÕÕÕ";
1590 Return

1600 Rem
1610 Rem @@@@ COUNT PLAYER'S PROPERTIES @@@@
1620 Rem
1630 H(L) = BH(L)
V = BV(L)
1640 PP = 0
For P = 1 To 39 ' loop through all properties except GO
    If PROPERTY_OWNER(P) <> PLAYER_MAP(L) Or PROPERTY_GROUP_NUM(P) >= 9 Then 1660 Else If RTP(PLAYER_MAP(L)) = P Then TP(PLAYER_MAP(L)) = PP
    1650 PP(PLAYER_MAP(L), PP) = P: PP = PP + 1: PPN(P) = PP
1660 Next P
1670 For G = 9 To 10
    For W = 1 To 4
        P = G(G, W)
        If PROPERTY_OWNER(P) <> PLAYER_MAP(L) Then 1690 Else If RTP(PLAYER_MAP(L)) = P Then TP(PLAYER_MAP(L)) = PP
        1680 PP(PLAYER_MAP(L), PP) = P: PP = PP + 1: PPN(P) = PP
1690 Next W, G
PLAYER_P(PLAYER_MAP(L)) = PP
If PLAYER_P(PLAYER_MAP(L)) <= 14 Then TP(PLAYER_MAP(L)) = 0: RTP(PLAYER_MAP(L)) = PP(PLAYER_MAP(L), TP(PLAYER_MAP(L)))
1700 Return
1710 Rem
1720 Rem @@@@ SHOW COLUMN OF PROPERTIES @@@@
1730 Rem
1740 Erase PD: For A1 = 0 To PLAYER_P(PLAYER_MAP(L)) - 1: A2 = PP(PLAYER_MAP(L), A1): CM(A2) = PROPERTY_M(A2): CO(A2) = PROPERTY_OWNER(A2): CU(A2) = PROPERTY_HOUSES(A2): CI(A2) = 0: Next A1: TP(PLAYER_MAP(L)) = PPN(RTP(PLAYER_MAP(L))) - 1: If TP(PLAYER_MAP(L)) < 0 Then TP(PLAYER_MAP(L)) = 0
1750 BF = 0: PP = TP(PLAYER_MAP(L)): For V = BV(L) To BV(L) + W# - 1
    1760 If PP > PLAYER_P(PLAYER_MAP(L)) - 1 Then If PLAYER_P(PLAYER_MAP(L)) > W# Then PP = 0 Else GoTo 1820
    1770 If PP = TP(PLAYER_MAP(L)) And V > BV(L) Then 1820 Else P = PP(PLAYER_MAP(L), PP)
    1780 Locate V, H(L): BP = P: If CO(P) <> PROPERTY_OWNER(P) Then MPC = PLAYER_COLOR(CO(P)) Else MPC = COLOR_ZZ - CM(P)
    1790 GoSub 10920: If CU(P) Then GoSub 11050: GoTo 1810
    1800 If PD(P) Then Color 14 * (1 + (PD(P) < 0)), 1: Print Using "####"; PD(P); Else Color , 0: Print "    ";
    1810 PP = PP + 1
1820 Next V
1830 Color , 0: For A1 = BV(L) + PLAYER_P(PLAYER_MAP(L)) To BV(L) + W# - 1
    1840 Locate A1, BH(L): Print "         ";
1850 Next A1: If DEAL_FLAG Then Return Else Return 'FOR A1=0 TO PLAYER_P(PLAYER_MAP(L))-1:A2=PP(PLAYER_MAP(L),A1):CM(A2)=0:CO(A2)=0:CU(A2)=0:NEXT A1:RETURN
1860 Rem
1870 Rem @@@@ SHOW HOUSES/HOTELS LEFT @@@@
1880 Rem
1890 CT = T: CE = E
1900 Color 2, 0: Locate B2 + 1, L2: Print Using "##"; 32 - CE;
1910 Color 4, 0: Locate B2 + 1, L2 + 31: Print Using "##"; 12 - CT;
1920 Return
1930 Rem
1940 Rem @@@@ PLAYER OPTIONS @@@@
1950 Rem
1960 PLAYER_PL = CL
1970 O$ = "": O$(1) = "roll": O$(2) = "deal": O$(3) = "player": O$(4) = "other": O = 4
1980 If PLAYER_OWES_MONEY_STATUS = 2 Or PLAYER_OWES_MONEY_STATUS = 3 Or PLAYER_OWES_MONEY_STATUS = 5 Then OO(0) = 0 Else OO(0) = 1
1990 If PLAYER_PL <> CL Or PLAYER_OWES_MONEY_STATUS Then OO(1) = 0 Else OO(1) = 1
2000 If PLAYER_P(PLAYER_MAP(PLAYER_PL)) = 0 And PLAYER_CASH(PLAYER_MAP(PLAYER_PL)) = 0 And FJ(PLAYER_MAP(PLAYER_PL)) = 0 Then OO(2) = 0 Else OO(2) = 1
2010 OO(3) = 0
If NUM_OF_PLAYERS > 1 Then
    For L = 1 To NUM_OF_PLAYERS
        If (PLAYER_P(PLAYER_MAP(L)) Or J(PLAYER_MAP(L)) Or PLAYER_CASH(PLAYER_MAP(L)) Or FJ(PLAYER_MAP(L))) And L <> PLAYER_PL Then OO(3) = 1
    Next L
End If
2020 If PLAYER_PL <> CL Then OO(3) = 1
2030 OO(4) = 1: GoSub 9940: On AA + 1 GOTO 2040, 4300, 11650, 2060, 10410
2040 If PLAYER_OWES_MONEY_STATUS Then Return Else GoTo 1940
2050 Rem
2060 Rem SET Player
2070 If NUM_OF_PLAYERS = 2 Then If PLAYER_PL = 1 Then PLAYER_PL = 2 Else PLAYER_PL = 1 Else GoTo 2110
2080 GoTo 11670
2110 GoSub 12161: If EPN = 0 Then GoSub 7330: GoTo 1940
2120 A = EPN: If PLAYER_P(PLAYER_MAP(A)) = 0 And J(PLAYER_MAP(A)) = 0 And FJ(PLAYER_MAP(A)) = 0 And PLAYER_CASH(PLAYER_MAP(A)) = 0 And A <> CL Then GoSub 11280: Color 7, 0: Locate B1 + 1, L2 + 2: GoSub 11280: Print Using "Player # has no assets"; PLAYER_MAP(A): GoSub 10310: GoSub 7330: GoTo 1940
2130 PLAYER_PL = Val(KEY_PRESSED$): GoTo 11670
2150 Rem
2160 Rem @@@@ JAIL PAYMENT OPTIONS @@@@
2170 Rem
2180 O$ = "BAIL-": O$(1) = "$50": O$(2) = "card": O = 2
2190 OO(1) = 1: If FJ(PLAYER_MAP(PLAYER_PL)) = 0 Then OO(2) = 0 Else OO(2) = 1
2200 If J(PLAYER_MAP(PLAYER_PL)) > 3 Then OO(0) = 0 Else OO(0) = 1
2210 GoSub 9940: If AA <> 1 Or PLAYER_CASH(PLAYER_MAP(PLAYER_PL)) >= 50 Then 2230
2220 PLAYER_CURRENT_PROPERTY((CL)) = CURRENT_PROPERTY_NUM: TRANSACTION_PLAYER_A = PLAYER_PL: PLAYER_PL1 = PLAYER_PL: PLAYER_OWES_MONEY_STATUS = 4: GoSub 7170: DUE = 50: GoSub 8320: GoSub 11650: GoSub 11320: PLAYER_OWES_MONEY_STATUS = 0: If J(PLAYER_MAP(PLAYER_PL1)) < 3 Then If PLAYER_CASH(PLAYER_MAP(PLAYER_PL)) < 50 Then 2180 Else GoTo 2240 Else GoTo 2240
2230 GoSub 7330: On AA + 1 GOTO 2300, 2240, 2250
2240 PLAYER1_DUE = -50: TRANSACTION_PLAYER_A = PLAYER_PL: PLAYER_PL1 = PLAYER_PL: GoSub 6590: J(PLAYER_MAP(PLAYER_PL)) = 0: GoTo 2270
2250 If J1 = PLAYER_MAP(PLAYER_PL) Then J1 = 0 Else J2 = 0
2260 L = CL: GoSub 1540: FJ(PLAYER_MAP(PLAYER_PL)) = FJ(PLAYER_MAP(PLAYER_PL)) - 1: J(PLAYER_MAP(PLAYER_PL)) = 0
2270 Color PLAYER_COLOR(PLAYER_MAP(PLAYER_PL)), 0: If PROPERTY_BOARD_NUM(PLAYER_CURRENT_PROPERTY(PLAYER_MAP(CL))) < 3 Then Locate Y(PLAYER_MAP(PLAYER_PL)), X(PLAYER_XN(PLAYER_MAP(PLAYER_PL)), PLAYER_MAP(PLAYER_PL)): Print " "
2280 Y(PLAYER_MAP(PLAYER_PL)) = T1 + 4: If CL = PLAYER_PL Then Y = Y(PLAYER_MAP(PLAYER_PL))
2290 If PROPERTY_BOARD_NUM(PLAYER_CURRENT_PROPERTY(PLAYER_MAP(CL))) < 3 Then Locate Y(PLAYER_MAP(PLAYER_PL)), X(PLAYER_XN(PLAYER_MAP(L)), PLAYER_MAP(PLAYER_PL)): Print Chr$(L(PLAYER_MAP(PLAYER_PL)))
2300 L = PLAYER_PL: GoSub 7240: If NOROLL Then NOROLL = 0: GoTo 4570 Else GoTo 11650
2310 Rem
2320 Rem  * DEAL *
2330 If PLAYER_P(PLAYER_MAP(TRADING_PLAYER_A)) = 0 Then 11680 Else GoSub 10350
2340 DDN = 0: DEAL_FLAG = 1: A = 1: LASTP1 = 0: LASTA = 1: SEE1 = 0: L = TRADING_PLAYER_A: Y1 = T4: X1 = L2 + 16: X1 = L2: Color PLAYER_COLOR(PLAYER_MAP(TRADING_PLAYER_A)), 0: Poke 1050, Peek(1052)
2350 Locate B1 + 1, X1 - 1: Print "[         |     |          |     |  ]"
2360 Rem  * opening variables *
2370 CE = E: CT = T: CPP = TP(PLAYER_MAP(TRADING_PLAYER_A)): V = BV(TRADING_PLAYER_A): For A1 = 1 To NUM_OF_PLAYERS: H(A1) = BH(A1): CW(PLAYER_MAP(A1)) = PLAYER_CASH(PLAYER_MAP(A1)): Next A1: CI$ = ""
2380 Erase PD, CI: For A1 = 0 To PLAYER_P(PLAYER_MAP(TRADING_PLAYER_A)) - 1: F = PP(PLAYER_MAP(TRADING_PLAYER_A), A1): CU(F) = PROPERTY_HOUSES(F): CM(F) = PROPERTY_M(F): CO(F) = PROPERTY_OWNER(F): Next A1
2390 GoSub 2460: GoSub 2400: GoTo 2620
2400 Rem * display info *
2410 If CO(P) <> PLAYER_MAP(TRADING_PLAYER_A) Then Color PLAYER_COLOR(CO(P)), 1 Else Color 14 + CM(P), 1
2420 Locate V, H(TRADING_PLAYER_A) + 1: Print PROPERTY_SHORT_NAMES$(P);
2430 Locate V, H(TRADING_PLAYER_A) + 5: If CU(P) = 0 Then If PD(P) Then Color 14 * (1 + (PD(P) < 0)), 1: Print Using "####"; PD(P); Else Color , 0: Print "    ";
2440 For L = 1 To NUM_OF_PLAYERS
    If CW(PLAYER_MAP(L)) <> PLAYER_CASH(PLAYER_MAP(L)) Then PLAYER_EXCHANGE = CW(PLAYER_MAP(L)) - PLAYER_CASH(PLAYER_MAP(L)): GoSub 1460 Else GoSub 1510
2450 Next L
GoSub 1900
2451 If CO(P) <> PLAYER_MAP(TRADING_PLAYER_A) Then Color PLAYER_COLOR(CO(P)), 1 Else Color 14 + CM(P), 1
2452 Locate V, H(TRADING_PLAYER_A) + 1: Print PROPERTY_SHORT_NAMES$(P);: Return
2460 Rem  * sort *
2470 P = PP(PLAYER_MAP(TRADING_PLAYER_A), CPP)
2480 DD = 1: DM = 1: DH = 1: DH1 = 1: DH2 = 1
2490 If CO(P) <> PLAYER_MAP(TRADING_PLAYER_A) Then DM = 0: DH = 0: DH1 = 0: DH2 = 0: GoTo 2590
2500 If PROPERTY_TYPE(P) < 3 Then DH = 0: DH1 = 0: DH2 = 0: GoTo 2580
2510 If CU(P) = 0 Or (CU(P) = 5 And CE > 28) Then DH2 = 0
2520 If (CU(P) >= PROPERTY_HOUSES(P) And CW(PLAYER_MAP(TRADING_PLAYER_A)) < 50 * PROPERTY_BOARD_NUM(P)) Or CU(P) = 5 Or (CU(P) < PROPERTY_HOUSES(P) And CW(PLAYER_MAP(TRADING_PLAYER_A)) < 25 * PROPERTY_BOARD_NUM(P)) Or (CU(P) = 4 And CT >= 12) Or (CU(P) < 4 And CE >= 32) Then DH1 = 0
2530 For A1 = 1 To 3: F = G(PROPERTY_GROUP_NUM(P), A1): If F = 0 Then 2570
    2540 If CM(F) Or CO(F) <> PLAYER_MAP(TRADING_PLAYER_A) Then DH = 0: DH1 = 0: DH2 = 0
    2550 If CU(F) Then DM = 0: DD = 0
    2560 DH1 = DH1 * Abs(1 + (CU(F) < CU(P))): DH2 = DH2 * Abs(1 + (CU(F) > CU(P)))
2570 Next A1: DH = DH1 + DH2
2580 If CM(P) Then DM = DM * (1 + (CW(PLAYER_MAP(TRADING_PLAYER_A)) < PROPERTY_COST(P) / 2 + PROPERTY_COST(P) / 20 * PROPERTY_M(P)))
2590 If (CM(P) And PROPERTY_COST(P) * .05 > CW(PLAYER_MAP(TRADING_PLAYER_B))) Or NUM_OF_PLAYERS < 2 Then DD = 0
2600 If CO(P) <> PLAYER_MAP(TRADING_PLAYER_A) And CW(PLAYER_MAP(TRADING_PLAYER_A)) - CI(P) < 0 Then DD = 0
2610 Return
2620 Rem * inkey$ *
2630 A = LASTA
2640 If (A = 3 And DH2 = 0) Then If DH1 Then A = 2: GoTo 2640 Else A = A + 1 Else If (A = 1 And DM = 0) Or (A = 2 And DH1 = 0) Or (A = 4 And DD = 0) Then A = A + 1 Else GoTo 2670
2650 If A > 6 Then A = 1 Else If A < 1 Then A = 6
2660 GoTo 2640
2670 GoSub 3760
2680 KEY_PRESSED$ = InKey$: On Len(KEY_PRESSED$) + 1 GOTO 2680, 2810, 2690
2690 KEY_PRESSED$ = Right$(KEY_PRESSED$, 1): If KEY_PRESSED$ = Chr$(77) Then AV = 1: GoTo 2710
2700 If KEY_PRESSED$ <> Chr$(75) Then 2730 Else AV = -1
2710 A = A + AV: If A < 1 Then A = 6 Else If A > 6 Then A = 1
2720 If (A = 1 And DM = 0) Or (A = 2 And DH1 = 0) Or (A = 3 And DH2 = 0) Or (A = 4 And DD = 0) Then 2710 Else LASTA = A: GoTo 2670 '2390
2730 If KEY_PRESSED$ = Chr$(80) Then LCPP = CPP: GoTo 3640
2740 If KEY_PRESSED$ = Chr$(72) Then LCPP = CPP: GoTo 3690
2750 If KEY_PRESSED$ <> Chr$(15) Then 2800
2760 If TRADING_PLAYER_B = 1 Then TRADING_PLAYER_B = NUM_OF_PLAYERS Else TRADING_PLAYER_B = TRADING_PLAYER_B - 1
2770 If DD Then A = 4
2780 If TRADING_PLAYER_B = TRADING_PLAYER_A Then 2760
2790 LASTA = A: GoSub 3760: GoTo 2390
2800 If KEY_PRESSED$ = Chr$(83) Then GoSub 3370: GoTo 2390 Else GoTo 2680
2810 If KEY_PRESSED$ = Chr$(13) Then If A = 6 Then 2930 Else GoTo 2910
2820 If KEY_PRESSED$ = "S" Or KEY_PRESSED$ = "s" Then A = 5: GoTo 2910
2830 If (KEY_PRESSED$ = "T" Or KEY_PRESSED$ = "t") And DD Then A = 4: GoTo 2910
2840 If (KEY_PRESSED$ = "M" Or KEY_PRESSED$ = "m") And DM Then A = 1: GoTo 2910
2850 If KEY_PRESSED$ = "-" And DH2 Then A = 3: GoTo 2910
2860 If KEY_PRESSED$ = "+" And DH1 Then A = 2: GoTo 2910
2870 If KEY_PRESSED$ <> Chr$(9) Then 2900 Else If TRADING_PLAYER_B = NUM_OF_PLAYERS Then TRADING_PLAYER_B = 1 Else TRADING_PLAYER_B = TRADING_PLAYER_B + 1
2880 If DD Then A = 4
2890 If TRADING_PLAYER_B = TRADING_PLAYER_A Then 2870 Else LASTA = A: GoSub 3760: GoTo 2390
2900 If (Val(KEY_PRESSED$) > 0 Or KEY_PRESSED$ = "0") And DD Then LASTA = A: GoSub 3510: GoTo 2390 Else If KEY_PRESSED$ = Chr$(27) Then 2930 Else GoTo 2680
2910 LASTA = A: On A GOSUB 3340, 3240, 3280, 3430, 3220
2920 GoTo 2390
2930 Rem  * end deal *
2940 Rem color over last p_symbol
2950 GoSub 7330: If CO(P) <> PLAYER_MAP(TRADING_PLAYER_A) Then Color PLAYER_COLOR(CO(P)), 0 Else Color COLOR_ZZ - CM(P), 0
2960 Locate V, H(TRADING_PLAYER_A) + 1: Print PROPERTY_SHORT_NAMES$(P);
2961 RTP(PLAYER_MAP(TRADING_PLAYER_A)) = PP(PLAYER_MAP(TRADING_PLAYER_A), TP(PLAYER_MAP(TRADING_PLAYER_A)))
2962 If KEY_PRESSED$ = Chr$(13) Then 3140

2970 Rem erase money fields
2980 For L = 1 To NUM_OF_PLAYERS
    GoSub 1510
Next L
2990 Rem redo gv's p_box
3010 L = TRADING_PLAYER_A: GoSub 1600: GoSub 1720
3020 Rem if a property card was shown during this menu... erase it
3030 LASTP1 = 0: If SEE1 Then GoSub 7020: SEE1 = 0 Else GoTo 3090
3040 Rem if any kind of card was shown before this menu... put it back
3050 If PLAYER_OWES_MONEY_STATUS Then SEE = 1: P1 = CURRENT_PROPERTY_NUM Else GoTo 3090
3060 If PROPERTY_SHORT_NAMES$(P1) = "?" Then SC = 1: GoSub 7460: GoTo 3090
3070 If PROPERTY_SHORT_NAMES$(P1) = "$" Then SC = 2: GoSub 7460: GoTo 3090
3080 GoSub 5020: SEE = 0
3090 Rem zero out all variables used here
3100 Rem erase pd,ci,co,cm,cu
3110 SEE = 0: GoSub 1860
3120 DEAL_FLAG = 0: DDN = 0: If KEY_PRESSED$ = Chr$(13) And PLAYER_OWES_MONEY_STATUS = 0 Then 1940 Else If KEY_PRESSED$ = Chr$(27) Then 11680 Else GoTo 11650
3130 Rem
3140 Rem * enter *
3150 Erase PD: PPP = P: For A1 = 0 To PLAYER_P(PLAYER_MAP(TRADING_PLAYER_A)) - 1: F = PP(PLAYER_MAP(TRADING_PLAYER_A), A1): PROPERTY_M(F) = CM(F): PROPERTY_HOUSES(F) = CU(F): PROPERTY_OWNER(F) = CO(F): Next A1: T = CT: E = CE: SB = PROPERTY_BOARD_NUM(CURRENT_PROPERTY_NUM): GoSub 1030
3160 Rem redo p_box'S
3190 For L = 1 To NUM_OF_PLAYERS: PLAYER_CASH(PLAYER_MAP(L)) = CW(PLAYER_MAP(L)): GoSub 7240: GoSub 1400: GoSub 1510
    3200 If DDN Or L = TRADING_PLAYER_A Then GoSub 1600: GoSub 1750
3210 Next L: GoSub 12020: P = PPP: GoTo 3020
3220 Rem  * see *
3230 P1 = PP(PLAYER_MAP(TRADING_PLAYER_A), CPP): If P1 = LASTP1 Then LASTP1 = 0: GoSub 7020: Return Else SEE1 = SEE1 + 1: Color COLOR_ZZ, 0: Locate T2, L2 + 1 / 2 * (R2 - L2) - 3: Print "ÕÕÕÕÕÕ": SEE = 1: LASTP1 = P1: GoSub 5020: SEE = 0: P1 = 0: Return
3240 Rem  * add houses *
3250 CU(P) = CU(P) + 1: If CU(P) = 5 Then CT = CT + 1: CE = CE - 4 Else CE = CE + 1
3260 If CU(P) > PROPERTY_HOUSES(P) Then WV = -50 * PROPERTY_BOARD_NUM(P) Else WV = -25 * PROPERTY_BOARD_NUM(P)
3270 GoTo 3310

3280 Rem  * subtract houses *
3290 CU(P) = CU(P) - 1: If CU(P) = 4 Then CT = CT - 1: CE = CE + 4 Else CE = CE - 1
3300 If CU(P) >= PROPERTY_HOUSES(P) Then WV = 50 * PROPERTY_BOARD_NUM(P) Else WV = 25 * PROPERTY_BOARD_NUM(P)
3310 PD(P) = PD(P) + WV: CW(PLAYER_MAP(TRADING_PLAYER_A)) = CW(PLAYER_MAP(TRADING_PLAYER_A)) + WV: Color 2, 0: Locate V, H(TRADING_PLAYER_A) + 5
3320 BP = P: GoSub 11050
3330 Return

3340 Rem  * mortgage *
3350 WV = PROPERTY_COST(P) * (.5 + .05 * PROPERTY_M(P))
If CM(P) Then
    CM(P) = 0
    WV = -WV
Else
    CM(P) = 1
End If
3360 PD(P) = PD(P) + WV: CW(PLAYER_MAP(TRADING_PLAYER_A)) = CW(PLAYER_MAP(TRADING_PLAYER_A)) + WV
Return

3370 Rem  * delete *
3380 If CO(P) <> PROPERTY_OWNER(P) And DD Then GoSub 3420: GoSub 2460
3390 If CM(P) <> PROPERTY_M(P) And DM Then GoSub 3340: GoSub 2460
3400 If CU(P) < PROPERTY_HOUSES(P) And DH1 Then GoSub 3240: GoSub 2460: GoTo 3400
3410 If CU(P) > PROPERTY_HOUSES(P) And DH2 Then GoSub 3280: GoSub 2460: GoTo 3410
Return

3420 Rem  * trade *
3430 RRV = TRADING_PLAYER_B: PWV = CI(P)
3440 If CO(P) = PLAYER_MAP(TRADING_PLAYER_A) Then CO(P) = PLAYER_MAP(TRADING_PLAYER_B): GoTo 3490
3450 TRADING_PLAYER_B = PLAYER_UNMAP(CO(P)): CO(P) = PLAYER_MAP(TRADING_PLAYER_A): CW(PLAYER_MAP(TRADING_PLAYER_A)) = CW(PLAYER_MAP(TRADING_PLAYER_A)) - CI(P): PD(P) = PD(P) - CI(P): CW(PLAYER_MAP(TRADING_PLAYER_B)) = CW(PLAYER_MAP(TRADING_PLAYER_B)) + CI(P): CI(P) = 0
3460 If PM(P) = 1 Then WV = PROPERTY_COST(P) * .55: PM(P) = 0: CM(P) = 1 Else If PM(P) = 2 Then WV = .05 * PROPERTY_COST(P): PM(P) = 0 Else GoTo 3480
3470 CW(PLAYER_MAP(TRADING_PLAYER_B)) = CW(PLAYER_MAP(TRADING_PLAYER_B)) + WV: GoTo 3480
3480 DDN = DDN - 1: GoTo 3540
3490 If CM(P) Then GoSub 3570: X1 = L2 + 16: Y1 = B1 + 1: COLOR_CC = PLAYER_COLOR(PLAYER_MAP(PLAYER_PL)): X1 = L2: Color PLAYER_COLOR(PLAYER_MAP(TRADING_PLAYER_A)), 0: Locate B1 + 1, X1 - 1: Print "[         |     |          |     |  ]": If PM(P) Then 3500 Else CO(P) = PLAYER_MAP(TRADING_PLAYER_A): GoTo 3560 Else GoTo 3500
3500 DDN = DDN + 1: GoTo 3540
3510 RRV = TRADING_PLAYER_B: If CM(P) <> 0 And PM(P) = 0 Then GoSub 3570 Else GoTo 3530
3520 X1 = L2 + 16: Y1 = B1 + 1: X1 = L2: Color PLAYER_COLOR(PLAYER_MAP(TRADING_PLAYER_A)), 0: Locate B1 + 1, X1 - 1: Print "[         |     |          |     |  ]": If PM = 0 Then 3560
3530 If CW(PLAYER_MAP(TRADING_PLAYER_B)) - Val(Right$(Str$(CI(P)), 3) + KEY_PRESSED$) + Val(CI$) < 0 Then 3560 Else If Val(CI$) = 0 And CO(P) = PLAYER_MAP(TRADING_PLAYER_A) Then DDN = DDN + 1
3531 CO(P) = PLAYER_MAP(TRADING_PLAYER_B)
3540 CI$ = Str$(CI(P)): LC = Val(CI$): LCPP = CPP: CI$ = Right$(CI$, 3) + KEY_PRESSED$: CI(P) = Val(CI$)
3550 WV = Val(CI$) - LC
CW(PLAYER_MAP(TRADING_PLAYER_B)) = CW(PLAYER_MAP(TRADING_PLAYER_B)) - WV
CW(PLAYER_MAP(TRADING_PLAYER_A)) = CW(PLAYER_MAP(TRADING_PLAYER_A)) + WV
PD(P) = PD(P) + WV
3560 TRADING_PLAYER_B = RRV: Return
3570 Rem  * Unmortgage?-now or later *
3580 GoSub 7330
If CW(PLAYER_MAP(TRADING_PLAYER_B)) < .55 * PROPERTY_COST(P) Then OO(2) = 0 Else OO(2) = 1
3590 O$ = "Unmortgage-": O$(1) = "later": O$(2) = "now": OO(1) = 1: OO(0) = 1: O = 2
3600 GoSub 9940
If AA = 1 Then PM(P) = 2: WV = -.05 * PROPERTY_COST(P) Else If AA = 2 Then PM(P) = 1: WV = -.55 * PROPERTY_COST(P): CM(P) = 0 Else GoTo 3620
3610 CW(PLAYER_MAP(TRADING_PLAYER_B)) = CW(PLAYER_MAP(TRADING_PLAYER_B)) + WV
3620 GoSub 7330
Return

3630 Rem  * move *
3640 LC = CI(P)
3650 LV = V: If CPP = PLAYER_P(PLAYER_MAP(TRADING_PLAYER_A)) - 1 Then If PLAYER_P(PLAYER_MAP(TRADING_PLAYER_A)) <= W# Then V = BV(TRADING_PLAYER_A): CPP = 0: GoTo 3730 Else CPP = 0 Else CPP = CPP + 1
3660 If V < BV(TRADING_PLAYER_A) + W# - 1 Then V = V + 1: GoTo 3730 Else TP(PLAYER_MAP(TRADING_PLAYER_A)) = TP(PLAYER_MAP(TRADING_PLAYER_A)) + 1: If TP(PLAYER_MAP(TRADING_PLAYER_A)) > PLAYER_P(PLAYER_MAP(TRADING_PLAYER_A)) - 1 Then TP(PLAYER_MAP(TRADING_PLAYER_A)) = 0
3670 L = TRADING_PLAYER_A: GoSub 1750: V = V - 1: GoTo 3750
3680 '
3690 LC = CI(P)
3700 LV = V: If CPP = 0 Then If PLAYER_P(PLAYER_MAP(TRADING_PLAYER_A)) <= W# Then CPP = PLAYER_P(PLAYER_MAP(TRADING_PLAYER_A)) - 1: V = BV(TRADING_PLAYER_A) + PLAYER_P(PLAYER_MAP(TRADING_PLAYER_A)) - 1: GoTo 3730 Else CPP = PLAYER_P(PLAYER_MAP(TRADING_PLAYER_A)) - 1 Else CPP = CPP - 1
3710 If V > BV(TRADING_PLAYER_A) Then V = V - 1: GoTo 3730 Else If TP(PLAYER_MAP(TRADING_PLAYER_A)) = 0 Then TP(PLAYER_MAP(TRADING_PLAYER_A)) = PLAYER_P(PLAYER_MAP(TRADING_PLAYER_A)) - 1 Else TP(PLAYER_MAP(TRADING_PLAYER_A)) = TP(PLAYER_MAP(TRADING_PLAYER_A)) - 1
3720 L = TRADING_PLAYER_A: GoSub 1750: V = BV(TRADING_PLAYER_A): GoTo 3750
3730 If CO(PP(PLAYER_MAP(TRADING_PLAYER_A), LCPP)) <> PLAYER_MAP(TRADING_PLAYER_A) Then Color PLAYER_COLOR(CO(PP(PLAYER_MAP(TRADING_PLAYER_A), LCPP))), 0 Else Color COLOR_ZZ - CM(PP(PLAYER_MAP(TRADING_PLAYER_A), LCPP)), 0
3740 Locate LV, BH(TRADING_PLAYER_A) + 1: Print PROPERTY_SHORT_NAMES$(PP(PLAYER_MAP(TRADING_PLAYER_A), LCPP));
3750 P = PP(PLAYER_MAP(TRADING_PLAYER_A), CPP): CI$ = Str$(CI(P)): GoSub 2460: GoSub 2451: GoTo 2620
3760 Rem         * menu *
3770 PC = PLAYER_COLOR(PLAYER_MAP(TRADING_PLAYER_A)): Locate B1 + 1, X1: If A = 1 Then Color 14, 1: Print "MORTGAGE";: GoTo 3790 Else If DM Then Color PC, 0 Else Color COLOR_ZZ, 0
3780 Print "mortgage";
3790 If DH Then Color PC, 0 Else Color COLOR_ZZ, 0
3800 Locate B1 + 1, X1 + 12: Print "";
3810 If A = 2 Then Color 14, 1 Else If DH1 Then Color PC, 0 Else Color COLOR_ZZ, 0
3820 Locate B1 + 1, X1 + 11: Print "+";
3830 If A = 3 Then Color 14, 1 Else If DH2 Then Color PC, 0 Else Color COLOR_ZZ, 0
3840 Locate B1 + 1, X1 + 13: Print "-";
3850 Locate B1 + 1, X1 + 17: If A = 4 Then Color 14, 1: Print Using "TRADE(#)"; TRADING_PLAYER_B;: GoTo 3870 Else If DD Then Color PC, 0 Else Color COLOR_ZZ, 0
3860 Print Using "trade(#)"; TRADING_PLAYER_B;
3870 Locate B1 + 1, X1 + 28: If A = 5 Then Color 14, 1: Print "SEE"; Else Color PC, 0: Print "see";
3880 If A = 6 Then Color 14, 1 Else Color PC, 0
3890 Locate B1 + 1, X1 + 34: Print "˚";
3900 Return
3910 Rem
3920 Rem @@@@ SEE @@@@
3930 Rem
3940 AA = 1: OAA = AA
3950 O$(1) = "∞?∞": O$(2) = "?": O$(3) = "$": O$(4) = "go": O$(5) = "jail": O$(6) = "free": O$(7) = "go2": O = 7: AA = OAA: GoSub 10010: OAA = AA
3960 If AA > 3 Then 3980 Else On AA + 1 GOTO 3970, 4010, 3990, 3990
3970 SB = PROPERTY_BOARD_NUM(PLAYER_CURRENT_PROPERTY(PLAYER_MAP(CL))): GoSub 1020: GoTo 10410
3980 SB = AA - 3: GoSub 1020: GoTo 3950
3990 SC = AA - 1: GoTo 7350
4000 Rem
4010 Rem @@@@ SEE A PROPERTY CARD @@@@
4020 Rem
4030 Poke 1050, Peek(1052): P = 1: X1 = L2 + 16
4040 LASTP1 = 0: L = PLAYER_PL: X1 = L2
4050 Locate B1 + 1, X1 + 1
4060 If PROPERTY_TYPE(P) > 2 Then 4090 Else Color 7, 0: If P <> 28 And P <> 12 Then 4080
4070 Print "€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€": GoTo 4100
4080 Print "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX": GoTo 4100
4090 Color PROPERTY_FOREGROUND_COLOR(P), PROPERTY_BACKGROUND_COLOR(P): Print "±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±"
4100 Color COLOR_ZZ, 0
4110 SP = 1 / 2 * ((R2 - L2) - Len(PROPERTY_NAMES$(P)))
4120 Locate B1 + 1, X1 + SP - 1
4130 Print " "; PROPERTY_NAMES$(P); " "
4140 KEY_PRESSED$ = InKey$
4150 If KEY_PRESSED$ = Chr$(13) Then If P = LASTP1 Then LASTP1 = 0: GoSub 7020: GoTo 4140 Else GoTo 4290
4160 If KEY_PRESSED$ = Chr$(27) Then LASTP1 = 0: GoSub 7330: GoSub 7030: GoTo 3950
4170 If Len(KEY_PRESSED$) = 2 And Right$(KEY_PRESSED$, 1) = Chr$(75) Then V1 = -1: N = 10: GoTo 4210
4180 If Len(KEY_PRESSED$) = 2 And Right$(KEY_PRESSED$, 1) = Chr$(77) Then V1 = 1: N = 10: GoTo 4210
4190 If Len(KEY_PRESSED$) = 2 And Right$(KEY_PRESSED$, 1) = Chr$(72) Then V1 = -1: N = 1: GoTo 4210
4200 If Len(KEY_PRESSED$) = 2 And Right$(KEY_PRESSED$, 1) = Chr$(80) Then V1 = 1: N = 1: GoTo 4210 Else GoTo 4140
4210 P = P + (V1 * N)
4220 If P > 39 Then P = P - 40
4230 If P < 1 Then P = P + 40
4240 If PROPERTY_TYPE(P) < 2 Then P = P + V1: GoTo 4220
4250 GoTo 4050
4260 GoSub 7060
4270 If PLAYER_OWES_MONEY_STATUS = 0 Then 3910
4280 SEE = 1: P1 = CURRENT_PROPERTY_NUM: GoSub 5020: GoTo 3910
4290 LASTP1 = P: P1 = P: SEE = 1: Locate T2, L2 + 1 / 2 * (R2 - L2) - 3: Print "ÕÕÕÕÕÕ": GoSub 5020: GoTo 4140

4300 Rem
4310 Rem @@@@ ROLL DICE @@@@
4320 Rem
4330 Randomize Timer
DIE1_ROLLED = Int(Rnd * 6 + 1)
Randomize Timer
DIE2_ROLLED = Int(Rnd * 6 + 1)
4340 IP = 1: GoSub 11180
If IP = 1 Then DIE1_ROLLED = INK: GoSub 11200: DIE2_ROLLED = INK
4350 DICE_ROLLED = DIE1_ROLLED + DIE2_ROLLED

4360 Rem
4370 Rem @@@@ SHOW DIEROLL @@@@
4380 Rem
4390 For D = 1 To DIE1_ROLLED
    If SOUNDS Then Play "mf O4 A64 P64"
    4400 Locate B1 + 1, L2 + 9: Color PLAYER_COLOR(PLAYER_MAP(CL)), 0
    4410 Print Using "[#]"; D
Next D
If SOUNDS Then Play "P16"
4420 For D = 1 To DIE2_ROLLED
    If SOUNDS Then Play "O4 A64 P64"
    4430 Locate B1 + 1, L2 + 21: Color PLAYER_COLOR(PLAYER_MAP(CL)), 0
    Print Using "[#]"; D
Next D

4440 Rem
4450 Rem @@@@ DOUBLES @@@@
4460 Rem
4470 If DIE1_ROLLED <> DIE2_ROLLED Then 
    Goto 4540
End If
4480 Locate B1 + 1, L2 + 13: Color 30, 1: Print "Doubles"
4490 If SOUNDS Then 
    REM TODO fix the following which results in an Illegal function call
    REM Play "Mf O3 A64 P64 A64 P64 A64 P32 X" + VarPtr$(PLY$)
    Play "Mf O3 A64 P64 A64 P64 A64 P32"
    If DOUBLES_IN_ROW_COUNT < 2 Then 
        Play "A"
    Else 
        Play "<A"
    End If
End if
4500 GoSub 10310: Locate B1 + 1, L2 + 13: Color , 0: Print "       "
4510 If J(PLAYER_MAP(CL)) Then Locate Y, X: Color , 0: Print " ": J(PLAYER_MAP(CL)) = 0: Y = T1 + 4: Y(PLAYER_MAP(CL)) = Y: DOUBLES_IN_ROW_COUNT = 0: GoTo 4590
4520 DOUBLES_IN_ROW_COUNT = DOUBLES_IN_ROW_COUNT + 1: If DOUBLES_IN_ROW_COUNT < 3 Then GoSub 11530: GoTo 4590 Else Locate Y, X: Color , 0: Print " ": DOUBLES_IN_ROW_COUNT = 0: J(PLAYER_MAP(CL)) = 1
4530 CURRENT_PROPERTY_NUM = 10: PLAYER_CURRENT_PROPERTY(PLAYER_MAP(CL)) = CURRENT_PROPERTY_NUM: Y = T1 + 1: Y(PLAYER_MAP(CL)) = Y: NX = R1 - KK + CL: X(1, PLAYER_MAP(CL)) = NX: L = CL: GoSub 7330: GoSub 7240: CA = CL: GoSub 8510: GoTo 7070
4540 DOUBLES_IN_ROW_COUNT = 0: GoSub 11530: If J(PLAYER_MAP(CL)) = 0 Then 4590 Else J(PLAYER_MAP(CL)) = J(PLAYER_MAP(CL)) + 1: Color 30, 1: Locate B1 + 1, L2 + 14
4550 Print Using "Day #"; J(PLAYER_MAP(CL)) - 1: GoSub 10310: GoSub 7330: If J(PLAYER_MAP(CL)) < 4 Then 7150 Else Color , 0
4560 Locate B1 + 1, L2 + 9: Print "               ": NOROLL = 1: GoTo 2150
4570 Locate Y(PLAYER_MAP(CL)), X(1, PLAYER_MAP(CL)): Print " "
4580 Locate B1 + 1, L2 + 9: Print Using "[#]         [#]"; DIE1_ROLLED; DIE2_ROLLED: J(PLAYER_MAP(CL)) = 0: Y = T1 + 4

4590 Rem
4600 Rem @@@@ CALCULATE PROPERTY TO LAND ON @@@@
4610 Rem
4620 LP = CURRENT_PROPERTY_NUM
For A = 1 To DICE_ROLLED
    CURRENT_PROPERTY_NUM = CURRENT_PROPERTY_NUM + 1 - 2 * BW_FLAG
    If CURRENT_PROPERTY_NUM < 0 Then CURRENT_PROPERTY_NUM = 40 Else If CURRENT_PROPERTY_NUM > 39 Then CURRENT_PROPERTY_NUM = 0
4630 Next A

4640 Rem
4650 Rem @@@@ MOVE PLAYER @@@@
4660 Rem
4670 NX = X
X = (B(PROPERTY_BOARD_NUM(CURRENT_PROPERTY_NUM), 10) - CURRENT_PROPERTY_NUM - 1) * 6 + 13 + L1
If PROPERTY_TYPE(CURRENT_PROPERTY_NUM) = 0 Then X = L1 + KK
4680 If CB Then Y = T1 + 4: CB = 0
4690 LX = NX
If J(PLAYER_MAP(CL)) = 0 Then NY = T1 + 4
4700 NX = NX - 1 + 2 * BW_FLAG
4710 If BW_FLAG = PO And NX = L1 + KK Then PLAYER1_DUE = 200: PLAYER_PL1 = PLAYER_PL: TRANSACTION_PLAYER_A = PLAYER_PL: GoSub 6590
4720 If NX = X And PO = CURRENT_PROPERTY_NUM Then AR = 1
4730 If Screen(Y, NX) = 179 Then PO = PO + 1 - 2 * BW_FLAG Else GoTo 4760
4740 If BW_FLAG Then If PO <= 0 Then PO = 40 Else GoTo 4750 Else If PO >= 40 Then PO = 0
4750 If MVE_FLAG Then MVE_FLAG = 0: AR = 1: If LP = CURRENT_PROPERTY_NUM Then NX = LX: GoTo 4770 Else NX = X: NY = T1 + 2: GoTo 4770 Else GoTo 4700
4760 If Screen(NY, NX) = 32 Then 4770 Else If PO = CURRENT_PROPERTY_NUM Then MVE_FLAG = 1: GoTo 4700 Else GoTo 4700
4770 Locate Y, LX: Color PLAYER_COLOR(PLAYER_MAP(CL)), 0: Print " ";: Locate NY, NX: Print Chr$(L(PLAYER_MAP(CL)))
4780 Y = NY: If AR Then AR = 0: BW_FLAG = 0: MVE_FLAG = 0: GoTo 4820 Else LP = PO
4790 If (BW_FLAG Or NX > L1 + KK) And (BW_FLAG = 0 Or NX < R1 - KK) Then 4810
4800 CB = 1: Locate Y, NX: Color , 0: Print " ";: If BW_FLAG Then NX = L1 + KK: GoTo 960 Else NX = R1 - 2: GoTo 960
4810 GoTo 4680
4820 If PROPERTY_TYPE(CURRENT_PROPERTY_NUM) > 0 Then 4850
4830 Y(PLAYER_MAP(CL)) = Y: If NX < L1 + 10 Then Color PLAYER_COLOR(PLAYER_MAP(CL)), 0: Locate Y(PLAYER_MAP(CL)), X(2, PLAYER_MAP(CL)): Print Chr$(L(PLAYER_MAP(CL))): Locate Y(PLAYER_MAP(CL)), NX: Print " "
4840 NX = R1 - KK + PLAYER_MAP(CL)
4850 Color , 0: Locate B1 + 1, L2: Print "                                   ": PLAYER_CURRENT_PROPERTY(PLAYER_MAP(CL)) = CURRENT_PROPERTY_NUM: L = CL: GoSub 7240: P1 = CURRENT_PROPERTY_NUM: X = NX: X(1, PLAYER_MAP(CL)) = NX
4860 Rem
4870 Rem @@@@ DEFINE CURRENT PROPERTY @@@@
4880 Rem
4890 Rem `PLAYY' IS CODED AS FOLLOWS ...
4900 Rem  1=CHANCE CARD                 6=ANY OTHER CORNER PROPERTY
4910 Rem  2=COMMUNITY CHEST CARD        7=OWN PLAYER'S PROPERTY
4920 Rem  3=LUXURY TAX                  8=NO OWNER...MAY BUY PROPERTY
4930 Rem  4=INCOME TAX                  9=NO MORTGAGE & OWNED..MUST PAY RENT
4940 Rem  5=GO TO JAIL                 10=PROPERTY MORTGAGED... NO RENT
4950 Rem       11=`PAYTWICE' ADVANCE FROM CHANCE
4960 If PROPERTY_SHORT_NAMES$(P1) = "?" Then SC = 1: PLAYY = 1: GoSub 7460: GoTo 7620
4970 If PROPERTY_SHORT_NAMES$(P1) = "$" Then SC = 2: PLAYY = 2: GoSub 7460: GoTo 7620
4980 If PROPERTY_NAMES$(P1) = "LUXURY TAX" Then PLAYY = 3: GoTo 6830
4990 If PROPERTY_NAMES$(P1) = "INCOME TAX" Then PLAYY = 4: GoTo 6760
5000 If PROPERTY_NAMES$(P1) = "GO TO JAIL" Then PLAYY = 5: GoTo 6870
5010 If PROPERTY_TYPE(P1) < 2 Then GO2 = 0: PLAYY = 6: GoTo 7070 Else GoTo 5800
5020 Rem
5030 Rem @@@@ SHOW PROPERTY INFORMATION @@@@
5040 Rem
5050 If RL <> 0 Then On PROPERTY_TYPE(P1) - 1 GOTO 5320, 5090
5060 Color COLOR_ZZ, 0: Locate T2, L2 + 10: Print String$(15, Chr$(205))
5070 SP = 1 / 2 * ((R2 - L2) - Len(PROPERTY_NAMES$(P1)))
5080 If PROPERTY_TYPE(P1) = 2 Then 5320
5090 If RL > 0 Then Color 30, 1 Else Color COLOR_ZZ, 0
5100 If RL Then On Abs(RL) GOTO 5110, 5200, 5210, 5220, 5230, 5240, 5250
5110 Locate T2, L2 + 1 / 2 * (R2 - L2) - 3
5120 If PROPERTY_COST(P1) > 99 Then Print Using "[$###.]"; PROPERTY_COST(P1) Else Print Using "[$##.]"; PROPERTY_COST(P1)
5130 If RL Then 5310 Else BC = PROPERTY_BACKGROUND_COLOR(P1): FC = PROPERTY_FOREGROUND_COLOR(P1)
5140 If PROPERTY_TYPE(P1) = 2 Then 5320 Else If RL Then 5090 Else BC = PROPERTY_BACKGROUND_COLOR(P1): FC = PROPERTY_FOREGROUND_COLOR(P1)
5150 Color FC, BC
5160 Locate T2 + 1, L2 + 1: Print "±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±"
5170 Locate , L2 + 1: Print "±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±"
5180 Locate , L2 + 1: Print "±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±"
5190 Color COLOR_ZZ, 0: SP = 1 / 2 * ((R2 - L2) - Len(PROPERTY_NAMES$(P1))): Locate T2 + 2, L2 + SP - 1: Print " "; PROPERTY_NAMES$(P1); " ": Locate T2 + 4, L2 + 1: Print "                                "
5200 Locate T2 + 5, L2 + 1: Print Using "            Rent  $$##.         "; RENT_RATES(0, P1): If RL Then 5310
5210 Locate T2 + 6, L2 + 1: Print Using " With 1 House              $###."; RENT_RATES(1, P1): If RL Then 5310
5220 Locate T2 + 7, L2 + 1: Print Using " With 2 Houses              ###."; RENT_RATES(2, P1): If RL Then 5310
5230 Locate T2 + 8, L2 + 1: Print Using " With 3 Houses             ####."; RENT_RATES(3, P1): If RL Then 5310
5240 Locate T2 + 9, L2 + 1: Print Using " With 4 Houses             ####."; RENT_RATES(4, P1): If RL Then 5310
5250 Locate T2 + 10, L2 + 1: Print Using "      With HOTEL $$####.        "; RENT_RATES(5, P1): If RL Then 5310
5260 Locate T2 + 11, L2 + 1: Print "                               "
5270 Locate T2 + 12, L2 + 1: Print Using "     Mortgage Value $$###.      "; 1 / 2 * PROPERTY_COST(P1)
5280 Locate T2 + 13, L2 + 1: Print Using "     Houses cost $$###. each    "; 50 * PROPERTY_BOARD_NUM(P1)
5290 Locate T2 + 14, L2 + 1: Print Using "   Hotels, $$###. plus 4 houses "; 50 * PROPERTY_BOARD_NUM(P1)
5300 Locate T2 + 15, L2 + 1: Print "                                ";
5310 If RL > 0 Then RL = -RL: GoSub 10310: GoTo 5090 Else RL = 0: Return
5320 Rem
5330 Rem @@@@ DRAW A R/R CARD @@@@
5340 Rem
5350 If B(PROPERTY_BOARD_NUM(P1), 5) <> P1 Then 5590
5360 If RL > 0 Then Color 30, 1 Else Color COLOR_ZZ, 0
5370 If RL Then On Abs(RL) GOTO 5380, 5470, 5480, 5490, 5500
5380 Locate T2, L2 + 1 / 2 * (R2 - L2) - 3: Print Using "[$###.]"; PROPERTY_COST(P1): If RL Then 5550
5390 Color COLOR_ZZ, 0: SP = 1 / 2 * ((R2 - L2) - Len(PROPERTY_NAMES$(P1)))
5400 Locate T2 + 1, L2 + 1: Print "                                "
5410 Locate T2 + 2, L2 + 1: Print "              è‹€               "
5420 Locate T2 + 3, L2 + 1: Print "              ¯ ¯               "
5430 Locate T2 + 4, L2 + 1: Print " ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ "
5440 Locate T2 + 5, L2 + 1: Print Space$(SP - 1)+PROPERTY_NAMES$(P1)+Space$(R2 - (L2 + SP + Len(PROPERTY_NAMES$(P1))) - 1)
5450 Locate T2 + 6, L2 + 1: Print " ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ "
5460 Locate T2 + 7, L2 + 1: Print "                                "
5470 Locate T2 + 8, L2 + 1: Print " Rent                      $25. ": If RL Then 5550
5480 Locate T2 + 9, L2 + 1: Print " If 2 R.R's are owned       50. ": If RL Then 5550
5490 Locate T2 + 10, L2 + 1: Print " If 3  "; Chr$(34); "     "; Chr$(34); "   "; Chr$(34); "         100. ": If RL Then 5550
5500 Locate T2 + 11, L2 + 1: Print " If 4  "; Chr$(34); "     "; Chr$(34); "   "; Chr$(34); "         200. ": If RL Then 5550
5510 Locate T2 + 12, L2 + 1: Print "                                "
5520 Locate T2 + 13, L2 + 1: Print "                                "
5530 Locate T2 + 14, L2 + 1: Print " Mortgage Value           $100. "
5540 Locate T2 + 15, L2 + 1: Print "                                ";
5550 If RL > 0 Then RL = -RL: GoSub 10310: GoTo 5360 Else RL = 0: Return
5560 Rem
5570 Rem @@@@ DRAW A UTILITY CARD @@@@
5580 Rem
5590 If P1 <> 12 And P1 <> 28 Then Return
5600 If RL > 0 Then Color 30, 1 Else Color COLOR_ZZ, 0
5610 If RL Then On Abs(RL) GOTO 5620, 5710, 5740
5620 Locate T2, L2 + 1 / 2 * (R2 - L2) - 3: Print Using "[$###.]"; PROPERTY_COST(P1): If RL Then 5790
5630 Color PROPERTY_FOREGROUND_COLOR(P1), 0
5640 Locate T2 + 1, L2 + 1: Print Space$(R2 - L2 - 1): Locate T2 + 2, L2 + 1: Print "              "; PROPERTY_SHORT_NAMES$(P1); Space$(15);
5650 Color COLOR_ZZ, 0
5660 Locate T2 + 3, L2 + 1: Print "                                "
5670 Locate T2 + 4, L2 + 1: Print " ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ "
5680 Locate T2 + 5, L2 + 1: Print Space$(SP - 1)+PROPERTY_NAMES$(P1)+Space$(R2 - (L2 + SP + Len(PROPERTY_NAMES$(P1))) - 1)
5690 Locate T2 + 6, L2 + 1: Print " ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ "
5700 Locate T2 + 7, L2 + 1: Print "                                "
5710 Locate T2 + 8, L2 + 1: Print "   If  one  "; Chr$(34); "Utility"; Chr$(34); "  is  owned"
5720 Locate T2 + 9, L2 + 1: Print "rent is 4 times the amount shown"
5730 Locate T2 + 10, L2 + 1: Print "on dice.                        ": If RL Then 5790
5740 Locate T2 + 11, L2 + 1: Print "  If   both   "; Chr$(34); "Utilities"; Chr$(34); "   are"
5750 Locate T2 + 12, L2 + 1: Print " owned  rent  is    10    times"
5760 Locate T2 + 13, L2 + 1: Print " amount   shown    on     dice.": If RL Then 5790
5770 Locate T2 + 14, L2 + 1: Print "                                "
5780 Locate T2 + 15, L2 + 1: Print "Mortgage Value              $75.";
5790 If RL > 0 Then RL = -RL: GoSub 10310: GoTo 5600 Else RL = 0: Return
5800 Rem
5810 Rem @@@@ CHECK PROPERTY OWNERSHIP @@@@
5820 Rem
5830 L = CL
GoSub 7240
GO2 = 0
If PROPERTY_OWNER(CURRENT_PROPERTY_NUM) = PLAYER_MAP(CL) Then PT_FLAG = 0: GoSub 11570: PLAYY = 7: GoSub 5870: GoTo 7070
5840 If PROPERTY_OWNER(CURRENT_PROPERTY_NUM) = 0 Then PT_FLAG = 0: GoSub 11570: PLAYY = 8: GoSub 5020: RL = 1: P1 = CURRENT_PROPERTY_NUM: GoSub 5020: GoTo 6000
5850 If PROPERTY_M(CURRENT_PROPERTY_NUM) = 0 Then PLAYY = 9 - 2 * (PLAYY = 1): GoSub 5870: P1 = CURRENT_PROPERTY_NUM: GoSub 5020: GoTo 6380
5860 PT_FLAG = 0: GoSub 11570: PLAYY = 10
GoSub 5870
GoTo 7070
5870 Rem
5880 Rem * BLINK PROPERTY *
5890 Rem
5900 H(PLAYER_UNMAP(PROPERTY_OWNER(CURRENT_PROPERTY_NUM))) = BH(PLAYER_UNMAP(PROPERTY_OWNER(CURRENT_PROPERTY_NUM)))
5910 V = BV(PLAYER_UNMAP(PROPERTY_OWNER(CURRENT_PROPERTY_NUM))) + PPN(CURRENT_PROPERTY_NUM) - 1 - TP(PROPERTY_OWNER(CURRENT_PROPERTY_NUM)) + PLAYER_P(PROPERTY_OWNER(CURRENT_PROPERTY_NUM)) * (1 + (PPN(CURRENT_PROPERTY_NUM) >= TP(PROPERTY_OWNER(CURRENT_PROPERTY_NUM))))
5920 If V >= BV(PLAYER_UNMAP(PROPERTY_OWNER(CURRENT_PROPERTY_NUM))) And V <= BV(PLAYER_UNMAP(PROPERTY_OWNER(CURRENT_PROPERTY_NUM))) + W# - 1 Then 5970
5930 If PROPERTY_OWNER(CURRENT_PROPERTY_NUM) = PROPERTY_OWNER(G(PROPERTY_GROUP_NUM(CURRENT_PROPERTY_NUM), 1)) Then TP(PROPERTY_OWNER(CURRENT_PROPERTY_NUM)) = PPN(G(PROPERTY_GROUP_NUM(CURRENT_PROPERTY_NUM), 1)) - 1: RTP(PROPERTY_OWNER(CURRENT_PROPERTY_NUM)) = G(PROPERTY_GROUP_NUM(CURRENT_PROPERTY_NUM), 1): GoTo 5960
5940 If PROPERTY_OWNER(CURRENT_PROPERTY_NUM) = PROPERTY_OWNER(G(PROPERTY_GROUP_NUM(CURRENT_PROPERTY_NUM), 2)) Then TP(PROPERTY_OWNER(CURRENT_PROPERTY_NUM)) = PPN(G(PROPERTY_GROUP_NUM(CURRENT_PROPERTY_NUM), 2)) - 1: RTP(PROPERTY_OWNER(CURRENT_PROPERTY_NUM)) = G(PROPERTY_GROUP_NUM(CURRENT_PROPERTY_NUM), 2): GoTo 5960
5950 If PROPERTY_OWNER(CURRENT_PROPERTY_NUM) = PROPERTY_OWNER(G(PROPERTY_GROUP_NUM(CURRENT_PROPERTY_NUM), 3)) Then TP(PROPERTY_OWNER(CURRENT_PROPERTY_NUM)) = PPN(G(PROPERTY_GROUP_NUM(CURRENT_PROPERTY_NUM), 3)) - 1: RTP(PROPERTY_OWNER(CURRENT_PROPERTY_NUM)) = G(PROPERTY_GROUP_NUM(CURRENT_PROPERTY_NUM), 3) Else TP(PROPERTY_OWNER(CURRENT_PROPERTY_NUM)) = PPN(CURRENT_PROPERTY_NUM) - 1: RTP(PROPERTY_OWNER(CURRENT_PROPERTY_NUM)) = PP(PROPERTY_OWNER(CURRENT_PROPERTY_NUM), PPN(CURRENT_PROPERTY_NUM) - 1)
5960 L = PROPERTY_OWNER(CURRENT_PROPERTY_NUM): GoSub 1740: GoTo 5910
5970 Locate V, H(PLAYER_UNMAP(PROPERTY_OWNER(CURRENT_PROPERTY_NUM))) + 1: Color 30 + PROPERTY_M(CURRENT_PROPERTY_NUM), 1: Print PROPERTY_SHORT_NAMES$(CURRENT_PROPERTY_NUM);
5980 GoSub 10310: Locate V, H(PLAYER_UNMAP(PROPERTY_OWNER(CURRENT_PROPERTY_NUM))) + 1: Color COLOR_ZZ - PROPERTY_M(CURRENT_PROPERTY_NUM), 0: Print PROPERTY_SHORT_NAMES$(CURRENT_PROPERTY_NUM);
5990 Return
6000 Rem
6010 Rem @@@@ LET PLAYER BUY PROPERTY @@@@
6020 Rem
6030 COLOR_CC = PLAYER_COLOR(PLAYER_MAP(CL))
L = CL: O$(1) = "buy": O$(2) = "auction": O = 2: OO(0) = 0: OO(1) = 1: OO(2) = 1
GoSub 9940
6040 If AA <> 1 Or PLAYER_CASH(PLAYER_MAP(CL)) >= PROPERTY_COST(CURRENT_PROPERTY_NUM) Then 6060
6050 PLAYER_CURRENT_PROPERTY(PLAYER_MAP(CL)) = CURRENT_PROPERTY_NUM
PLAYER_PL1 = CL
PLAYER_PL = CL
PLAYER_OWES_MONEY_STATUS = 1
GoSub 7170
DUE = PROPERTY_COST(CURRENT_PROPERTY_NUM)
GoSub 8320
GoSub 11650
GoSub 11320
PLAYER_OWES_MONEY_STATUS = 0
If PLAYER_CASH(PLAYER_MAP(CL)) < PROPERTY_COST(CURRENT_PROPERTY_NUM) Then 6030 Else AA = 1
6060 On AA GOTO 6070, 6090
6070 PLAYER1_DUE = -PROPERTY_COST(CURRENT_PROPERTY_NUM)
TRANSACTION_PLAYER_A = CL: PLAYER_PL1 = CL
GoSub 6590
6080 PROPERTY_OWNER(CURRENT_PROPERTY_NUM) = PLAYER_MAP(CL): L = CL
GoSub 1600
GoSub 1710
GoTo 7010

6090 Rem
6100 Rem @@@@ AUCTION OFF PROPERTY @@@@
6110 Rem
6120 Poke 1050, Peek(1052)
6130 X1 = L2 + 16: Y1 = B1 + 1: CIV = 1: L = CL: X1 = L2
For L = 1 To NUM_OF_PLAYERS
    I(PLAYER_MAP(L)) = 0
Next L
HB = CL
If CL = NUM_OF_PLAYERS Then CI = 1 Else CI = CL + 1
6140 CI$ = "0"
6150 GoSub 11320
6160 Locate B1, L2 + 6: Color PLAYER_COLOR(PLAYER_MAP(HB)), 0: Print Using "[High bid **$#####,]"; I(PLAYER_MAP(HB))
6170 I$ = InKey$
If I$ <> Chr$(13) Then 6240
6180 L = CI
GoSub 1510
CI$ = Right$(CI$, 6)
6190 If Val(CI$) = 0 Then 6140
6200 I(PLAYER_MAP(CI)) = Val(CI$)
If Not I(PLAYER_MAP(CI)) > 0 Then 6140
For L = 1 To NUM_OF_PLAYERS
    6210 If I(PLAYER_MAP(CI)) <= I(PLAYER_MAP(L)) And L <> CI Then CHECK = 1
6220 Next L
If CHECK Then
    CHECK = 0
    GoTo 6170
Else
    HB = CI
    CI = CI + CIV
    If CI > NUM_OF_PLAYERS Then
        CI = 1
    ElseIf CI < 1 Then
        CI = NUM_OF_PLAYERS
    End If
End If
6230 GoTo 6140
6240 If Len(I$) = 2 And Right$(I$, 1) = Chr$(83) Then CI$ = "0"
6250 If I$ <> Chr$(9) And I$ <> Chr$(27) Then 6280
6260 GoSub 11320
6270 For L = 1 To NUM_OF_PLAYERS
    GoSub 1510
Next L
GoSub 7330
If I$ = Chr$(27) Then 6000 Else GoTo 6360
6280 If Len(I$) = 2 And Right$(I$, 1) = Chr$(77) Then CIV = 1: GoTo 6300
6290 If Len(I$) = 2 And Right$(I$, 1) = Chr$(75) Then CIV = -1 Else GoTo 6320
6300 L = CI: GoSub 1510: CI = CI + CIV
6310 If CI > NUM_OF_PLAYERS Then CI = 1 Else If CI < 1 Then CI = NUM_OF_PLAYERS
6320 If Val(I$) Or I$ = "0" Then 6330 Else GoTo 6340
6330 CI$ = Right$(CI$, 3) + I$
6340 CI$ = Right$(CI$, 6)
6350 PLAYER_EXCHANGE = -Val(CI$): L = CI: GoSub 1460: GoTo 6170
6360 GoSub 7330: CI = HB: PLAYER1_DUE = -I(PLAYER_MAP(CI)): TRANSACTION_PLAYER_A = CI: PLAYER_PL1 = CI: GoSub 6590: PROPERTY_OWNER(CURRENT_PROPERTY_NUM) = PLAYER_MAP(CI): L = CI: CI = 0
6370 GoSub 1390: GoSub 1600: GoSub 1710: GoTo 7010

6380 Rem
6390 Rem @@@@ PLAYER PAYS RENT TO OWNER @@@@
6400 Rem
6410 RR = 1
For P = 1 To 4
    If G(PROPERTY_GROUP_NUM(CURRENT_PROPERTY_NUM), P) <> CURRENT_PROPERTY_NUM And PROPERTY_OWNER(G(PROPERTY_GROUP_NUM(CURRENT_PROPERTY_NUM), P)) = PROPERTY_OWNER(CURRENT_PROPERTY_NUM) Then RR = RR + 1
6420 Next P
On PROPERTY_TYPE(CURRENT_PROPERTY_NUM) - 1 GOTO 6430, 6530
6430 On PROPERTY_GROUP_NUM(CURRENT_PROPERTY_NUM) - 8 GOTO 6450, 6470

6440 Rem @@@@ RENT ON R/R @@@@
6450 RL = RR + 1: P1 = CURRENT_PROPERTY_NUM
GoSub 5020
R = 25 * 2 ^ (RR - 1)
GoTo 6570

6460 Rem @@@@ RENT ON UTLITIES @@@@
6470 On RR GOTO 6480, 6490
6480 R = 4 * DICE_ROLLED: RL = 2
GoTo 6500
6490 R = 10 * DICE_ROLLED: RL = 3
6500 P1 = CURRENT_PROPERTY_NUM
GoSub 5020
If PT_FLAG Then R = 10 * DICE_ROLLED
6510 GoTo 6580

6520 Rem @@@@ RENT ON PROPERTY CARD @@@@
6530 R = RENT_RATES(PROPERTY_HOUSES(CURRENT_PROPERTY_NUM), CURRENT_PROPERTY_NUM)
RL = PROPERTY_HOUSES(CURRENT_PROPERTY_NUM) + 2
P1 = CURRENT_PROPERTY_NUM
GoSub 5020
6540 If PROPERTY_GROUP_NUM(CURRENT_PROPERTY_NUM) = 1 Or PROPERTY_GROUP_NUM(CURRENT_PROPERTY_NUM) = 8 Then 6550 Else GoTo 6560
6550 If RR = 2 And PROPERTY_HOUSES(CURRENT_PROPERTY_NUM) = 0 Then R = 2 * R: GoTo 6570
6560 If RR = 3 And PROPERTY_HOUSES(CURRENT_PROPERTY_NUM) = 0 Then R = 2 * R
6570 If PT_FLAG Then R = R * 2
6580 TRANSACTION_PLAYER_A = CL: TRANSACTION_PLAYER_B = PLAYER_UNMAP(PROPERTY_OWNER(CURRENT_PROPERTY_NUM)): PLAYER1_DUE = -R: PLAYER2_DUE = R: PLAYER_PL1 = PLAYER_PL
GoSub 6590
PT_FLAG = 0
GoSub 11570
GoTo 7010

6590 Rem
6600 Rem @@@@ COLLECT/PAY MONEY @@@@
6610 Rem
6620 If SHOWING_CARD_FLAG Then TRANSACTION_PLAYER_A = CL
6630 If PLAYER1_DUE = 0 Then If PLAYER2_DUE = 0 Then 6730 Else GoTo 6700
6640 If TRANSACTION_ALL_PLAYERS_FLAG Then
    For TRANSACTION_PLAYER_B = 1 To NUM_OF_PLAYERS
        If TRANSACTION_PLAYER_B! = TRANSACTION_PLAYER_A Then GoSub 6650
    Next TRANSACTION_PLAYER_B
Else
    GoSub 6650
End If
6645 PLAYER1_DUE = 0: PLAYER2_DUE = 0: TRANSACTION_PLAYER_A = 0: TRANSACTION_PLAYER_B = 0: TRANSACTION_ALL_PLAYERS_FLAG = 0
Return

Rem
Rem @@@@ COLLECT/PAY MONEY subroutine @@@@
Rem
6650 If PLAYER_CASH(PLAYER_MAP(TRANSACTION_PLAYER_A)) + PLAYER1_DUE >= 0 Then 6670
6660 L = TRANSACTION_PLAYER_A: DUE = Abs(PLAYER1_DUE): GoSub 8320: PLAYER_CURRENT_PROPERTY(PLAYER_MAP(CL)) = CURRENT_PROPERTY_NUM: PLAYER_OWES_MONEY_STATUS = 3: PLAYER_PL = TRANSACTION_PLAYER_A: PLAYER_PL1 = TRANSACTION_PLAYER_A: PL2 = TRANSACTION_PLAYER_B: PLAYER1_DUE_TMP = PLAYER1_DUE: PLAYER2_DUE_TMP = PLAYER2_DUE: GoSub 7170: GoSub 12123: GoSub 11650: GoSub 11320: PLAYER_OWES_MONEY_STATUS = 0: TRANSACTION_PLAYER_A = PLAYER_PL1: TRANSACTION_PLAYER_B = PL2: PLAYER1_DUE = PLAYER1_DUE_TMP: PLAYER2_DUE = PLAYER2_DUE_TMP: GoTo 6600
6670 Color 14, 1: PLAYER_CASH(PLAYER_MAP(TRANSACTION_PLAYER_A)) = PLAYER_CASH(PLAYER_MAP(TRANSACTION_PLAYER_A)) + PLAYER1_DUE: L = TRANSACTION_PLAYER_A: PLAYER_EXCHANGE = PLAYER1_DUE: GoSub 1460
6680 If PLAYER2_DUE = 0 Then GoSub 10310: GoTo 6730
6690 If PLAYER_CASH(PLAYER_MAP(TRANSACTION_PLAYER_B)) + PLAYER2_DUE >= 0 Then 6710
6700 L = TRANSACTION_PLAYER_B: DUE = Abs(PLAYER2_DUE): GoSub 8320: PLAYER_CURRENT_PROPERTY(PLAYER_MAP(CL)) = CURRENT_PROPERTY_NUM: PLAYER_OWES_MONEY_STATUS = 5: PLAYER_PL = TRANSACTION_PLAYER_B: PLAYER_PL1 = TRANSACTION_PLAYER_B: PL2 = TRANSACTION_PLAYER_A: PLAYER1_DUE_TMP = PLAYER1_DUE: PLAYER2_DUE_TMP = PLAYER2_DUE: GoSub 7170: GoSub 12123: GoSub 11650: GoSub 11320: PLAYER_OWES_MONEY_STATUS = 0: TRANSACTION_PLAYER_A = PL2: TRANSACTION_PLAYER_B = PLAYER_PL1: PLAYER1_DUE = PLAYER1_DUE_TMP: PLAYER2_DUE = PLAYER2_DUE_TMP: GoTo 6590
6710 PLAYER_CASH(PLAYER_MAP(TRANSACTION_PLAYER_B)) = PLAYER_CASH(PLAYER_MAP(TRANSACTION_PLAYER_B)) + PLAYER2_DUE: L = TRANSACTION_PLAYER_B: PLAYER_EXCHANGE = PLAYER2_DUE: GoSub 1460: GoSub 10310
6720 L = TRANSACTION_PLAYER_B: GoSub 1510: GoSub 1400
6730 L = TRANSACTION_PLAYER_A: GoSub 1510: GoSub 1400
Return

6760 Rem
6770 Rem @@@@ INCOME TAX @@@@
6780 Rem
6790 O$ = "Income Tax Payment-"
O$(1) = "$200"
O$(2) = "10%"
O = 2
OO(0) = 0
OO(1) = 1
OO(2) = 1
GoSub 9940
6800 On AA GOTO 6820, 6810
6810 PLAYER1_DUE = -PLAYER_CASH(PLAYER_MAP(CL))
Color 14, 1
For A = 0 To PLAYER_P(PLAYER_MAP(CL)) - 1
    F = PP(PLAYER_MAP(CL), A)
    PLAYER1_DUE = PLAYER1_DUE - PROPERTY_COST(F) - 50 * PROPERTY_BOARD_NUM(F) * PROPERTY_HOUSES(F)
    L = CL
    PLAYER_EXCHANGE = PLAYER1_DUE * .1
    GoSub 1460
Next A
PLAYER1_DUE = PLAYER1_DUE * .1
TRANSACTION_PLAYER_A = PLAYER_PL
PLAYER_PL1 = PLAYER_PL
GoSub 6590
GoTo 7010

6820 PLAYER1_DUE = -200: TRANSACTION_PLAYER_A = PLAYER_PL: PLAYER_PL1 = PLAYER_PL: GoSub 6590: GoTo 7010
6830 Rem
6840 Rem @@@@ LUXURY TAX @@@@
6850 Rem
6860 PLAYER1_DUE = -75: TRANSACTION_PLAYER_A = PLAYER_PL: PLAYER_PL1 = PLAYER_PL: GoSub 6590: GoTo 7010
6870 Rem
6880 Rem @@@@ GO TO JAIL @@@@
6890 Rem
6900 DOUBLES_IN_ROW_COUNT = 0: GoSub 11530: Color PLAYER_COLOR(PLAYER_MAP(CL)), 0: If SHOWING_CARD_FLAG Then Locate Y, NX Else Locate Y, X(2, PLAYER_MAP(CL))
6910 Print " ": CURRENT_PROPERTY_NUM = 10: PLAYER_CURRENT_PROPERTY(PLAYER_MAP(CL)) = CURRENT_PROPERTY_NUM: Y = T1 + 1: Y(PLAYER_MAP(CL)) = Y: NX = R1 - KK + CL: X(1, PLAYER_MAP(CL)) = NX: J(PLAYER_MAP(CL)) = 1: L = CL: GoSub 7240: CA = CL: GoSub 8510: GoTo 7010
6920 Rem
6930 Rem @@@@ ADVANCE TO GO @@@@
6940 Rem
6950 PLAYER1_DUE = 200: TRANSACTION_PLAYER_A = CL: PLAYER_PL1 = CL: GoSub 6590
6960 Color PLAYER_COLOR(PLAYER_MAP(CL)), 0: Locate Y, NX: Print " ": SB = PROPERTY_BOARD_NUM(CURRENT_PROPERTY_NUM): G2 = CL: GoSub 1020: G2 = 0
6970 X = (B(PROPERTY_BOARD_NUM(CURRENT_PROPERTY_NUM), 10) - CURRENT_PROPERTY_NUM - 1) * 6 + 13 + L1: NXV = 1: NX = X: Y = T1 + 4
6980 If Screen(Y, NX) <> 32 Then If Screen(Y, NX) = 179 Then If NXV = 1 Then NX = X: NXV = -1 Else Y = T1 + 2: NX = X: GoTo 7000 Else GoTo 6990 Else GoTo 7000
6990 NX = NX + NXV: GoTo 6980
7000 Locate Y, NX: Color PLAYER_COLOR(PLAYER_MAP(CL)), 0: Print Chr$(L(PLAYER_MAP(CL))): GO2 = 1
7010 L = CL: GoSub 7240: GoSub 7020: GoTo 7070
7020 Rem
7030 Rem @@@@ ERASE PROPERTY CARD @@@@
7040 Rem
7050 If SHOWING_CARD_FLAG Then SHOWING_CARD_FLAG = 0
7060 GoSub 9760: For A = T2 + 1 To B2 - 1: Locate A, L2 + 1: Print Space$(32);: Next A: Return
7070 Rem
7080 Rem @@@@ SET VARIABLES AGAIN @@@@
7090 Rem
7100 PLAYER_CURRENT_PROPERTY(PLAYER_MAP(CL)) = CURRENT_PROPERTY_NUM
7110 X(1, PLAYER_MAP(CL)) = NX
7120 Y(PLAYER_MAP(CL)) = Y
7130 If PLAYER_OWES_MONEY_STATUS Then 1360
7140 If CB Or GO2 Or DOUBLES_IN_ROW_COUNT Then 960
7150 If CL = NUM_OF_PLAYERS Then CURRENT_PROPERTY_NUM = PLAYER_CURRENT_PROPERTY(PLAYER_MAP(1)) Else CURRENT_PROPERTY_NUM = PLAYER_CURRENT_PROPERTY(PLAYER_MAP(CL + 1))
7160 GoTo 960

7170 Rem
7180 Rem @@@@ WHEN NOT ENOUGH MONEY @@@@
7190 Rem
7200 Color 30, 1: L = PLAYER_PL: GoSub 1430
7210 LA$ = "O6 B64 A64 G64 F64 B64 F64 C64": LB$ = "O5 A64 B64 C64 D64 E64 F64 C64"
7220 If SOUNDS Then Play "MF" + LA$ + LA$ + LA$ + LB$ + LA$ + LB$ + LA$ + LB$
7230 L = PLAYER_PL: GoSub 10310: GoSub 1400
Return

7240 Rem
7250 Rem @@@@ SHOW CURRENT PROPERTIES @@@@
7260 Rem
7270 BF = 0: BP = PLAYER_CURRENT_PROPERTY(PLAYER_MAP(L)): Locate T6, BH(L): Color PLAYER_COLOR(PLAYER_MAP(L)), 0: PSS = 1 / 2 * WH - 1 / 2 * Len(PROPERTY_SHORT_NAMES$(BP))
7280 Print String$(Int(PSS + (PROPERTY_TYPE(BP) > 1)) - 1, Chr$(205)); "[";
7290 If BP = 10 And J(PLAYER_MAP(L)) Then Color 0, 6: Print "JAIL"; Else GoSub 10880
7300 Color PLAYER_COLOR(PLAYER_MAP(L)), 0: PSS = Pos(O) + 1: Print "]"; String$(BH(L) + WH - PSS, Chr$(205))
7310 Return

7320 Rem erase menu
7330 Color 0, 0: Locate T4, 1: Print Space$(80);
Return
7340 Color 0, 0: Locate T5, L2: Print Space$(32)
Return

7350 Rem
7360 Rem SEECARD
7370 Rem
7380 LASTCARD = 0: If SC = 1 Then Color 6, 0: Locate T2, L2 + 14: Print "Chance" Else Color 3, 0: Locate T2, L2 + 9: Print "Community Chest"
7390 Color 7, 0: Locate B1 + 1, L2 + 3: Print Using "ENTER 2-DIGIT CARD NUM [01-##]"; CARDS_PER_TYPE: INK$ = ""
7400 KEY_PRESSED$ = InKey$: If Len(KEY_PRESSED$) = 0 Then 7400
7410 If Val(KEY_PRESSED$) Or KEY_PRESSED$ = "0" Then INK$ = INK$ + KEY_PRESSED$ Else If KEY_PRESSED$ = Chr$(27) Then SEE = 0: GoSub 7330: GoSub 7060: GoTo 3950 Else GoSub 11280: GoTo 7400
7420 If Len(INK$) < 2 Then 7400 Else AA = Val(INK$)
7430 If AA > CARDS_PER_TYPE Or AA < 1 Then GoSub 11280: INK$ = "": GoTo 7400
7440 CARD = AA: If CARD = LASTCARD Then LASTCARD = 0: Color 0, 0: GoSub 11150: GoTo 7390 Else Color 0, 9 - 3 * SC: GoSub 11150
7450 LASTCARD = CARD
GoSub 7580
GoTo 7390

7460 Rem
7470 Rem @@@@ SHOW CHANCE/COMMUNITY CHEST CARD @@@@
7480 Rem
7490 SHOWING_CARD_FLAG = 1: PM = 0: If SC = 2 Then 7540
7500 Color 6, 0: Locate T2, L2 + 15: Print "Chance": Color 0, 6: GoSub 11150
7510 If PLAYER_OWES_MONEY_STATUS = 0 Then C1 = C1 + 1: If C1 > CARDS_PER_TYPE Then C1 = 1
7520 IP = 2: GoSub 11180: If IP = 2 Then CHANCE_CARDS(C1) = INK
7530 CARD = CHANCE_CARDS(C1): If J1 And CARD = 5 Then 7510 Else GoTo 7580
7540 Color 3, 0: Locate T2, L2 + 10: Print "Community Chest": Color 0, 3: GoSub 11150
7550 If PLAYER_OWES_MONEY_STATUS = 0 Then C2 = C2 + 1: If C2 > CARDS_PER_TYPE Then C2 = 1
7560 IP = 2: GoSub 11180: If IP = 2 Then COMMUNITY_CHEST_CARDS(C2) = INK
7570 CARD = COMMUNITY_CHEST_CARDS(C2): If J2 And CARD = 14 Then 7550
7580 Color 0, 9 - SC * 3: For A = 1 To Val(CARD$(SC, CARD, 0))
    7590 Locate T3 + (7 - Val(CARD$(SC, CARD, 0)) - 1) / 2 + A - 1, L3 + (30 - Len(CARD$(SC, CARD, A)) + 1) / 2
7600 Print CARD$(SC, CARD, A);: Next A: Return
7610 Return

7620 Rem
7630 Rem @@@@ CARRY OUT CHANGES/EFFECTS OF CARDS @@@@
7640 Rem
7650 PAUSE_SECS = 2 * PAUSE_SECS: GoSub 10310: PAUSE_SECS = PAUSE_SECS / 2
7660 GoSub 7060
7670 If PROPERTY_NAMES$(CURRENT_PROPERTY_NUM) = "COMMUNITY CHEST" Then 7890
7680 On CHANCE_CARDS(C1) GOTO 7690, 7700, 7710, 7720, 7730, 7740, 7750, 7760, 7770, 7780, 7790, 7800, 7840, 7850, 7860, 7870

7690 PLAYER1_DUE = 50
GoTo 8100

7700 TRANSACTION_PLAYER_B = 1: TRANSACTION_ALL_PLAYERS_FLAG = 1: PLAYER1_DUE = -50: PLAYER2_DUE = 50
GoTo 8100

7710 PT_FLAG = 1: If CURRENT_PROPERTY_NUM = 7 Then CURRENT_PROPERTY_NUM = 12: GoTo 8120 Else If CURRENT_PROPERTY_NUM = 22 Then CURRENT_PROPERTY_NUM = 28: GoTo 8120 Else CURRENT_PROPERTY_NUM = 12: GoTo 8110

7720 BW_FLAG = 1: DICE_ROLLED = 3
GoTo 8150

7730 FJ(PLAYER_MAP(CL)) = FJ(PLAYER_MAP(CL)) + 1: J1 = PLAYER_MAP(CL)
GoTo 8130

7740 If CURRENT_PROPERTY_NUM = 36 Then CURRENT_PROPERTY_NUM = 24: GoTo 8110 Else CURRENT_PROPERTY_NUM = 24: GoTo 8120

7750 CURRENT_PROPERTY_NUM = 39
GoTo 8120

7760 PT_FLAG = 1: If CURRENT_PROPERTY_NUM = 7 Then CURRENT_PROPERTY_NUM = 15: GoTo 8120 Else If CURRENT_PROPERTY_NUM = 22 Then CURRENT_PROPERTY_NUM = 25: GoTo 8120 Else CURRENT_PROPERTY_NUM = 5: GoTo 8110
7770 If CURRENT_PROPERTY_NUM = 7 Then CURRENT_PROPERTY_NUM = 11: GoTo 8120 Else CURRENT_PROPERTY_NUM = 11: GoTo 8110
7780 PLAYER1_DUE = -15: GoTo 8100
7790 CURRENT_PROPERTY_NUM = 0: GoTo 8110
7800 For A = 0 To PLAYER_P(PLAYER_MAP(CL)) - 1
    7810 If PROPERTY_HOUSES(PP(PLAYER_MAP(CL), A)) = 5 Then PLAYER1_DUE = PLAYER1_DUE - 100
    7820 If PROPERTY_HOUSES(PP(PLAYER_MAP(CL), A)) < 5 Then PLAYER1_DUE = PLAYER1_DUE - (25 * (PROPERTY_HOUSES(PP(PLAYER_MAP(CL), A))))
7830 Next A: GoTo 8100
7840 PLAYER1_DUE = 150: GoTo 8100
7850 GoTo 8140
7860 CURRENT_PROPERTY_NUM = 5: GoTo 8110
7870 PT_FLAG = 1: If CURRENT_PROPERTY_NUM = 7 Then CURRENT_PROPERTY_NUM = 15: GoTo 8120 Else If CURRENT_PROPERTY_NUM = 22 Then CURRENT_PROPERTY_NUM = 25: GoTo 8120 Else CURRENT_PROPERTY_NUM = 5: GoTo 8110

7880 Rem
7890 On COMMUNITY_CHEST_CARDS(C2) GOTO 7900, 7910, 7920, 7930, 7940, 7950, 7960, 7970, 7980, 7990, 8000, 8010, 8050, 8060, 8070, 8080
7900 PLAYER1_DUE = 10: GoTo 8100
7910 PLAYER1_DUE = 45: GoTo 8100
7920 PLAYER1_DUE = -150: GoTo 8100
7930 PLAYER1_DUE = 200: GoTo 8100
7940 GoTo 8140
7950 CURRENT_PROPERTY_NUM = 0: GoTo 8110
7960 PLAYER1_DUE = -50: GoTo 8100
7970 PLAYER1_DUE = 25: GoTo 8100
7980 PLAYER1_DUE = 100: GoTo 8100
7990 PLAYER1_DUE = 100: GoTo 8100
8000 PLAYER1_DUE = 200
GoTo 8100

8010 For A = 0 To PLAYER_P(PLAYER_MAP(CL)) - 1
    8020 If PROPERTY_HOUSES(PP(PLAYER_MAP(CL), A)) = 5 Then PLAYER1_DUE = PLAYER1_DUE - 115
    8030 If PROPERTY_HOUSES(PP(PLAYER_MAP(CL), A)) < 5 Then PLAYER1_DUE = PLAYER1_DUE - (40 * (PROPERTY_HOUSES(PP(PLAYER_MAP(CL), A))))
8040 Next A
GoTo 8100

8050 PLAYER1_DUE = -100
GoTo 8100

8060 FJ(PLAYER_MAP(CL)) = FJ(PLAYER_MAP(CL)) + 1: J2 = PLAYER_MAP(CL)
GoTo 8130

8070 PLAYER1_DUE = 20
GoTo 8100

8080 TRANSACTION_PLAYER_B = 1: TRANSACTION_ALL_PLAYERS_FLAG = 1: PLAYER1_DUE = 50: PLAYER2_DUE = -50
GoTo 8100

8090 Rem
8100 PLAYER_CURRENT_PROPERTY(PLAYER_MAP(CL)) = CURRENT_PROPERTY_NUM: GoSub 6590: GoTo 7010 'MONEY
8110 GoSub 11570: PLAYER_CURRENT_PROPERTY(PLAYER_MAP(CL)) = CURRENT_PROPERTY_NUM: GoTo 6950 'GO2[+$200]
8120 GoSub 11570: PLAYER_CURRENT_PROPERTY(PLAYER_MAP(CL)) = CURRENT_PROPERTY_NUM: GoTo 6960 'GO2
8130 PLAYER_CURRENT_PROPERTY(PLAYER_MAP(CL)) = CURRENT_PROPERTY_NUM: L = CL: GoSub 1540: GoTo 7010 'FREE CARDS
8140 PLAYER_CURRENT_PROPERTY(PLAYER_MAP(CL)) = CURRENT_PROPERTY_NUM: GoTo 6870 'JAIL
8150 PLAYER_CURRENT_PROPERTY(PLAYER_MAP(CL)) = CURRENT_PROPERTY_NUM: GoTo 4590 'BACK 3

8160 Rem
8170 Rem @@@@ Eliminate Player @@@@
8180 Rem
8190 O$ = "Eliminate Player #" + Str$(L) + "-": O$(1) = "yes": O$(2) = "no": O = 2: GoSub 10000
If AA <> 1 Then GoSub 7330: Return
8200 For P = 1 To 39
    If PROPERTY_OWNER(P) = PLAYER_MAP(L) Then PROPERTY_OWNER(P) = 0: PROPERTY_M(P) = 0
8210 Next P
8220 FJ(PLAYER_MAP(PLAYER_PL)) = 0
If J1 = PLAYER_MAP(L) Then J1 = 0
8230 If J2 = PLAYER_MAP(L) Then J2 = 0
8240 LL2 = PLAYER_MAP(L)
' Shift remaining players to left to close gap left by eliminated player
For LL1 = L To NUM_OF_PLAYERS - 1
    PLAYER_MAP(LL1) = PLAYER_MAP(LL1 + 1)
Next LL1
PLAYER_MAP(NUM_OF_PLAYERS) = LL2
8250 For LL1 = 1 To MAX_PLAYERS
    PLAYER_UNMAP(PLAYER_MAP(LL1)) = LL1
Next LL1
8260 NUM_OF_PLAYERS = NUM_OF_PLAYERS - 1
8270 If L < CL Then CL = CL - 1 Else If CL > NUM_OF_PLAYERS Then CL = 1
8280 If L = CL Then DOUBLES_IN_ROW_COUNT = 0: PT_FLAG = 0
8290 CURRENT_PROPERTY_NUM = PLAYER_CURRENT_PROPERTY(PLAYER_MAP(CL))
SG = 1
FM = 1
If PLAYER_OWES_MONEY_STATUS And PLAYER_PL1 = L Then PLAYER_OWES_MONEY_STATUS = 0
8300 Return

8310 Rem
8320 Rem *DUE*
8330 GoSub 10360
8340 Locate B1, L2 + 11: Color 14, 1: Print Using "[Due**$###]"; DUE: Return
8350 Rem
8360 Rem **** SAVE GAME IN GN$ ****
8370 Locate B1 + 1, L2 + 7: Color 7, 0: Print Using "Saving:`&'"; GN$
8380 Open "O", #1, GN$ + ".MF": Write #1, CL, CURRENT_PROPERTY_NUM, NX, Y, DOUBLES_IN_ROW_COUNT, NUM_OF_PLAYERS, J1, J2, T, E, C1, C2, PAUSE_SECS, SOUNDS, PLAYER_OWES_MONEY_STATUS, PLAYER1_DUE, PLAYER2_DUE, PLAYER_PL, PLAYER_PL1, PL2, TRANSACTION_PLAYER_A, TRANSACTION_PLAYER_B, PLAYER1_DUE_TMP, PLAYER2_DUE_TMP, TRANSACTION_ALL_PLAYERS_FLAG, NOROLL, DIE1_ROLLED, DIE2_ROLLED, PT_FLAG, PLAYY
8390 For J = 1 To MAX_PLAYERS: Write #1, J$(J), J(J), L(J), PLAYER_CURRENT_PROPERTY(J), X(1, J), Y(J), PLAYER_CASH(J), PLAYER_COLOR(J), FJ(J), RTP(J), TP(J), PLAYER_MAP(J), PLAYER_UNMAP(J), OCC3(J), OCCR(J): Next J
8400 For P = 1 To CARDS_PER_TYPE: Write #1, CHANCE_CARDS(P), COMMUNITY_CHEST_CARDS(P): Next P
8410 For P = 1 To 40: Write #1, PROPERTY_OWNER(P), PROPERTY_HOUSES(P), PROPERTY_M(P): Next P: Close #1: GoSub 7330: Return
8420 Rem
8430 Rem **** LOAD GAME FROM GN$ ****
8440 Locate B1 + 1, L2 + 7: Color 7, 0: Print Using "Loading:`&'"; GN$
8450 Open "I", #1, GN$ + ".MF": Input #1, CL, CURRENT_PROPERTY_NUM, NX, Y, DOUBLES_IN_ROW_COUNT, NUM_OF_PLAYERS, J1, J2, T, E, C1, C2, PAUSE_SECS, SOUNDS, PLAYER_OWES_MONEY_STATUS, PLAYER1_DUE, PLAYER2_DUE, PLAYER_PL, PLAYER_PL1, PL2, TRANSACTION_PLAYER_A, TRANSACTION_PLAYER_B, PLAYER1_DUE_TMP, PLAYER2_DUE_TMP, TRANSACTION_ALL_PLAYERS_FLAG, NOROLL, DIE1_ROLLED, DIE2_ROLLED, PT_FLAG, PLAYY
8460 For J = 1 To MAX_PLAYERS: Input #1, J$(J), J(J), L(J), PLAYER_CURRENT_PROPERTY(J), X(1, J), Y(J), PLAYER_CASH(J), PLAYER_COLOR(J), FJ(J), RTP(J), TP(J), PLAYER_MAP(J), PLAYER_UNMAP(J), OCC3(J), OCCR(J): Next J
8470 For P = 1 To CARDS_PER_TYPE: Input #1, CHANCE_CARDS(P), COMMUNITY_CHEST_CARDS(P): Next P
8480 For P = 1 To 40: Input #1, PROPERTY_OWNER(P), PROPERTY_HOUSES(P), PROPERTY_M(P): Next P: Close #1: GoSub 7330: Return
8490 Rem
8500 Rem DISPLAY PLAYER'S CHARACTER
8510 CAB = SB
8520 Color PLAYER_COLOR(PLAYER_MAP(CA)), 0
8530 If PROPERTY_BOARD_NUM(PLAYER_CURRENT_PROPERTY(PLAYER_MAP(CA))) = CAB Then PLAYER_XN(PLAYER_MAP(CA)) = 1: GoTo 8550
8540 If PROPERTY_TYPE(PLAYER_CURRENT_PROPERTY(PLAYER_MAP(CA))) = 0 And PROPERTY_BOARD_NUM(PLAYER_CURRENT_PROPERTY(PLAYER_MAP(CA))) = CAB Mod 4 + 1 Then PLAYER_XN(PLAYER_MAP(CA)) = 2 Else GoTo 8560
8550 Locate Y(PLAYER_MAP(CA)), X(PLAYER_XN(PLAYER_MAP(CA)), PLAYER_MAP(CA)): If EB Then Print " " Else Print Chr$(L(PLAYER_MAP(CA)))
8560 Return
8570 Rem **** POSITION PLAYERS' BOARD
8580 L1 = 3: R1 = L1 + 74: T1 = 1: B1 = T1 + 5
8590 If NUM_OF_PLAYERS = 1 Then L2 = 4: BH(1) = (80 - 9 + 33 + L2) / 2
8600 If NUM_OF_PLAYERS = 2 Then L2 = 24: BH(1) = (L2 - 9) / 2: BH(2) = (L2 - 9) / 2 + L2 + 33
8610 If NUM_OF_PLAYERS = 3 Then L2 = 4: BH(1) = (80 + L2 + 33 - 9) / 3 + 4: BH(2) = (80 + L2 + 33 - 9) / 2 + 1: BH(3) = (80 + L2 + 33 - 9) * 2 / 3 - 2
8620 If NUM_OF_PLAYERS = 4 Then L2 = 24: BH(1) = 3: BH(2) = BH(1) + 11: BH(3) = L2 + 35: BH(4) = BH(3) + 11
8630 T2 = B1 + 2: B2 = T2 + 16: R2 = L2 + 33
8640 T3 = T2 + 4: B3 = T3 + 6: L3 = L2 + 1: R3 = R2 - 1
8650 T4 = B1 + 1: T5 = B1 + 2: W6 = 9: H6 = 14: W# = 14: T6 = B1 + 2: B6 = T6 + H6 - 1
8660 For L = 1 To 4
    BV(L) = T6 + 3
Next L
8670 Return

8680 Rem
8690 Rem save file names
8700 Open "O", #1, "M.FF"
For A = 0 To GN
    Write #1, GN$(A)
Next A
Close #1
Return

8710 Rem
8720 Rem load file names
8730 Open "I", #1, "M.FF"
For A = 0 To 59
    If EOF(1) Then GN = A - 1: Exit For
    Input #1, GN$(A)
Next A
8750 Close #1
If GN = -1 Then SG = 0 Else SG = 1
Return

8760 Rem
8770 Rem choose from saved game list
8780 Poke 1050, Peek(1052)
8790 Screen 0, , 1, 0: Color , 0: Cls: Screen 0, , 1, 1
8800 Color , 0: Cls: Screen 0, , 1, 1
8810 X1 = 33: X2 = 43: If GN > 19 Then X1 = 28: X2 = 51: If GN > 39 Then X1 = 26: X2 = 62
8820 Color 7, 0: Locate 2, X1 - 1: Print "…" + String$(X2 - X1 + 1, Chr$(205)) + "ª";
8830 For A = 0 To GN: Locate A + 3, X1 - 1: Print "∫";: Locate , X2 + 1: Print "∫";: Next A
8840 Locate A + 3, X1 - 1: Print "»" + String$(X2 - X1 + 1, Chr$(205)) + "º";
8850 Color 7, 0: For A = 0 To GN: YY = A Mod 20 + 3: XX = X1 + Fix(A / 20) * 13: Locate YY, XX: Print Using "##)"; A + 1;: Print GN$(A) + Space$(8 - Len(GN$(A)));: Next: A = 0 'FOR A=YY+1 TO 22:LOCATE A,XX:PRINT SPACE$(11):NEXT A:A=0
8860 YY = A Mod 20 + 3: XX = X1 + Fix(A / 20) * 13: Color 14, 1: Locate YY, XX: Print Using "##)"; A + 1;: Print GN$(A) + Space$(8 - Len(GN$(A)));
8870 KEY_PRESSED$ = InKey$: On Len(KEY_PRESSED$) + 1 GOTO 8870, 8880, 8900
8880 If KEY_PRESSED$ = Chr$(13) Then 8970
8890 If KEY_PRESSED$ = Chr$(27) Then SG = 0: Screen 0, , 0, 0: Return Else GoTo 8870
8900 KEY_PRESSED$ = Right$(KEY_PRESSED$, 1): If KEY_PRESSED$ = Chr$(83) Then Kill GN$(A) + ".MF": For C = A To GN: GN$(C) = GN$(C + 1): Next C: GN = GN - 1: GoSub 8680: If GN < 0 Then KEY_PRESSED$ = Chr$(27): GoTo 8890 Else GoTo 8800
8910 Color 7, 0: Locate YY, XX: Print Using "##)"; A + 1;: Print GN$(A) + Space$(8 - Len(GN$(A)));
8920 If KEY_PRESSED$ = Chr$(80) Then If A = GN Or (A + 1) Mod 20 = 0 Then If GN > 0 Then A = Int((A - 1) / 20) * 20 Else A = 0 Else A = A + 1
8930 If KEY_PRESSED$ = Chr$(72) Then If A Mod 20 = 0 Then If A + 19 > GN Then A = GN Else A = Int(A / 20 + 1) * 20 - 1 Else A = A - 1
8940 If KEY_PRESSED$ = Chr$(75) Then If A < 20 Then If A <= GN Mod 20 Then A = A + Int(GN / 20) * 20 Else A = A + Int(GN / 20 - 1) * 20 Else A = A - 20
8950 If KEY_PRESSED$ = Chr$(77) Then If A > GN - 20 Then A = A Mod 20 Else A = A + 20
8960 GoTo 8860

8970 GN$ = GN$(A): Color , 0: Cls: Screen 0, , 0, 1: Cls: Screen 0, , 0, 0
Return

8980 Rem
8990 Rem ERRORS
9000 Color 14, 4: Locate T2 + 1, L2 + 1
9010 GoSub 10310: Color 0, 0: Locate T2 + 1, L2 + 1: Print Space$(31)
Return

9020 Rem
9030 Rem ERASE GAME FILE
START_GAME = 0
9040 For A = 0 To 59
    If Not GN$ <> GN$(A) Then Exit For
    START_GAME = A
Next A
9050 For A = START_GAME To 59
    GN$(A) = GN$(A + 1)
Next A
GN = GN - 1
Kill GN$ + ".MF"
Return

9060 Rem
9070 Rem ACCEPT INFORMATION
9080 KYL = 8: KYTF = 7: KYF = 14: KYB = 1: KYFSTR$ = "\" + Space$(KYL - 2) + "\": KYA = 1: KYY = B1 + 1: KY$ = String$(KYL, 97)
9090 KYFSTR$ = "\" + Space$(KYL - 2) + "\": KY$ = Space$(KYL)
9100 INS = 0: KYX = L2 + (32 - Len(KYT$) - KYL) / 2: Color KYTF, 0: Locate KYY, KYX: Print KYT$;: KYX = KYX + Len(KYT$)
9110 KY = 1
9120 Locate KYY, KYX: Color KYF, KYB: Print Using KYFSTR$; K$
9130 If KY > KYL Then KY = KYL Else If KY < 1 Then KY = 1
9140 If INS Then Locate , , , 4, 7 Else Locate , , , 7, 0
9150 KY$ = InKey$
9160 Locate KYY, KYX + KY - 1, 1
9170 If Len(KY$) Then 9180 Else GoTo 9150
9180 Locate , , 0
9190 If KY$ = Chr$(13) Then 9380
9200 If KY$ = Chr$(9) Then If KY = 1 Then KY = KYL: GoTo 9120 Else KY = 1: GoTo 9120
9210 If KY$ = Chr$(27) Then GoSub 7330: K$ = "": Return
9220 If Len(KY$) <> 2 Or Right$(KY$, 1) <> Chr$(83) Then 9240
9230 Mid$(K$, KY, KYL - KY + 1) = Mid$(K$, KY + 1, KYL - KY) + " ": GoTo 9120
9240 If Len(KY$) <> 2 Or Right$(KY$, 1) <> Chr$(82) Then 9270
9250 If INS = 0 Then INS = 1 Else INS = 0
9260 GoTo 9120
9270 If Len(KY$) <> 2 Or Right$(KY$, 1) <> Chr$(75) Then 9290
9280 KY = KY - 1: GoTo 9120
9290 If Len(KY$) <> 1 Or KY$ <> Chr$(8) Then 9310
9300 KY = KY - 1: GoTo 9230
9310 If Len(KY$) <> 2 Or Right$(KY$, 1) <> Chr$(77) Then 9330
9320 KY = KY + 1: GoTo 9120
9330 If Len(KY$) <> 1 Or (KYA = 2 And KY$ <> "0" And Val(KY$) = 0) Then 9120
9340 If INS Then 9360 Else If Len(K$) < KY Then K$ = K$ + KY$ Else Mid$(K$, KY, 1) = KY$
9350 KY = KY + 1: GoTo 9120
9360 K$ = Left$(K$, KY - 1) + KY$ + Left$(Right$(K$, KYL - KY + 1), KYL - KY)
9370 KY = KY + 1: GoTo 9120
9380 GoSub 7330: Return
9390 Rem
9400 Rem checking routine for a filename
9410 DUP = 0: If K$ <> Space$(8) And K$ <> "" Then GoSub 9540: GoSub 9490: OK$ = K$: GoSub 9580 Else DUP = 1: Return
9420 If K$ <> OK$ Then GoSub 9060: GoTo 9400 Else DUP = 0
9430 GoSub 7330: GoSub 9450: If DUP Then GoSub 9860: If DUP Then Return Else GoSub 8680: Return
9440 GN = GN + 1: GN$(GN) = K$: GN$ = K$: GoSub 9790: GoSub 8680: Return
9450 Rem
9460 Rem SEARCH FOR DUPLICATE FILES
9470 DUP = 0: For A = 0 To GN: If K$ = GN$(A) Then DUP = 1
9480 Next A: Return
9490 Rem
9500 Rem ERASE SPACES IN FILE NAME
9510 H = Len(K$): If Right$(K$, 1) = Chr$(32) Then K$ = Left$(K$, H - 1): GoTo 9510
9520 H = Len(K$): If Left$(K$, 1) = Chr$(32) Then K$ = Right$(K$, H - 1): GoTo 9520
9530 Return

9540 Rem
9550 Rem capitalize file names
9560 For A = 1 To Len(K$): KEY_PRESSED$ = Mid$(K$, A, 1): If Asc(KEY_PRESSED$) >= 97 And Asc(KEY_PRESSED$) <= 122 Then Mid$(K$, A, 1) = Chr$(Asc(KEY_PRESSED$) - 32)
9570 Next A
Return

9580 Rem
9590 Rem replace spaces with underscore chr's
9600 For A = 1 To Len(K$): AA = Asc(Right$(K$, A))
    9610 If AA = 33 Or (AA > 34 And AA < 42) Or AA = 45 Or (AA > 47 And AA < 58) Or (AA > 63 And AA < 91) Or (AA > 93 And AA < 97) Or AA = 123 Or AA = 125 Then 9640
    9620 If AA = 32 Then If Right$(K$, A) = Space$(A) Then 9640
    9630 K$ = Left$(K$, Len(K$) - A) + "_" + Right$(K$, A - 1)
9640 Next A
Return

9650 Rem
9660 Rem END/SAVE GAME OPTIONS
9670 NW = 0: ED = 0: DUP = 0: O$ = "": OO(0) = 1: O$(1) = "save": OO(1) = 1: O$(2) = "end": OO(2) = 1: O$(3) = "new": OO(3) = 1: O$(4) = "load": GoSub 8710: If SG Then OO(4) = 1 Else OO(4) = 0
9680 O = 4: GoSub 9960
9690 On AA + 1 GOTO 9710, 9720, 9740, 9750, 9700
9700 GoSub 8760: If SG Then GoSub 8430: CGN$ = GN$: GoSub 9020: GoSub 8690: GoSub 750: FM = 1: Return 890 Else GoTo 9660
9710 NW = 0: ED = 0: Return
9720 GoSub 8710: KYT$ = "File name:": K$ = CGN$: GoSub 9060: GoSub 9400: If DUP = 0 Then GN$ = K$: GoSub 8350: CGN$ = GN$
9730 GoTo 9650
9740 Color COLOR_ZZ, 0: Cls: ED = 1: NW = 0: Return
9750 NW = 1: ED = 0
Return

9760 Rem
9770 Rem blank TOP OF CARD BOX
9780 Locate T2, L2 + 1: Color COLOR_ZZ, 0: Print String$(32, Chr$(205));
Return

9790 Rem
9800 Rem Alphabetize FILE NAMES
9810 D = GN
9820 D = Int(D / 5) + 1
For I = 0 To GN - D
    For J = I To 0 Step -D
        If GN$(J) > GN$(J + D) Then Swap GN$(J), GN$(J + D)
9830 Next J, I
9840 If D > 1 Then GoTo 9820
9850 Return

9860 Rem
9870 Rem REPLACE EXISTING GAME FILE WITH K$??
9880 O$ = "Replace old `" + K$ + "'-": O$(1) = "yes": O$(2) = "no": O = 2: GoSub 10000
9890 If AA = 1 Then DUP = 0: Return Else DUP = 1
Return

9900 Rem
9910 Rem menus
9920 Rem
9930 Rem O$=Text:O$()=Options 1-5:O=# of options:a=foreground color:b=background color:c=highlighting color:d=background highlight color:x1=center x pos:y1=verticle pos:aa=current option #
9940 AA = 1
9950 Y1 = T4: X1 = L2 + 16: A = PLAYER_COLOR(PLAYER_MAP(PLAYER_PL)): B = 0: C = 14: D = 1: GoTo 10020
9960 AA = 1
9970 Y1 = T4: X1 = L2 + 16: A = 7: B = 0: C = 14: D = 1: GoTo 10020
9980 AA = 1
9990 Y1 = T4: X1 = L2 + 16: A = PLAYER_COLOR(PLAYER_MAP(PLAYER_PL)): B = 0: C = 14: D = 1: For F = 0 To O: OO(F) = 1: Next F: GoTo 10020
10000 AA = 1
10010 Y1 = T4: X1 = L2 + 16: A = 7: B = 0: C = 14: D = 1: For F = 0 To O: OO(F) = 1: Next F
10020 If InKey$ <> "" Then GoSub 10350
10030 Def Seg = 0: Poke 1050, Peek(1052)
10040 XX = Len(O$): For F = 1 To O: XX = XX + Len(O$(F)) + 3: Next F: XX = X1 - Int((XX - 3) / 2)
10050 If XX < 1 Then XX = 1
10060 Color A, B: Locate Y1, XX: Print O$ + "[";: For FF = 1 To O - 1: GoSub 10270: Print O$(FF) + " | ";: Next FF: GoSub 10270: Print O$(O) + "]";: F = 0
10070 If OO(AA) = 0 Then If AA < O Then AA = AA + 1: GoTo 10070
10080 If AA > O Then If F = 1 Then AA = 0: Return Else AA = 1: F = 1: GoTo 10070
10090 XXX = XX + Len(O$) + 1: Locate Y1, XXX: For F = 1 To O: If AA = F Then Color C, D: Print OO$(F); Else If OO(F) = 0 Then Color COLOR_ZZ, B: Print O$(F) Else Color A, B: Print O$(F);
10100 XXX = XXX + Len(O$(F)) + 3: Locate Y1, XXX: Next
10110 If AUTOKYBD Then KEY_PRESSED$ = Chr$(13) Else KEY_PRESSED$ = InKey$: On Len(KEY_PRESSED$) + 1 GOTO 10110, 10120, 10150
10120 If KEY_PRESSED$ = Chr$(13) Then 10230
10130 If KEY_PRESSED$ = Chr$(27) And OO(0) = 1 Then AA = 0: GoTo 10230
MENU_ITEM_SELECTED_FLAG = 0
10140 For F = 1 To O
    If (Asc(KEY_PRESSED$) = Asc(O$(F)) Or Asc(KEY_PRESSED$) = Asc(OO$(F))) And OO(F) Then
        AA = F
        MENU_ITEM_SELECTED_FLAG = 1
        Exit For
    End If
Next F
If MENU_ITEM_SELECTED_FLAG Then GoTo 10230 Else GoTo 10110
10150 KEY_PRESSED$ = Right$(KEY_PRESSED$, 1): If KEY_PRESSED$ <> Chr$(77) Then 10180
10160 If AA = O Then AA = 1 Else AA = AA + 1
10170 If OO(AA) = 0 Then 10160 Else GoTo 10090
10180 If KEY_PRESSED$ <> Chr$(75) Then 10210
10190 If AA = 1 Then AA = O Else AA = AA - 1
10200 If OO(AA) = 0 Then 10190 Else GoTo 10090
10210 If Asc(KEY_PRESSED$) >= 120 And Asc(KEY_PRESSED$) <= 129 Then PAUSE_SECS = (Asc(KEY_PRESSED$) - 120): GoTo 10110
10220 If KEY_PRESSED$ = Chr$(79) Then GoSub 7330: GoSub 9650: If ED Then End Else GoTo 10 Else GoTo 10110
10230 XXX = XX + Len(O$) + 1: Locate Y1, XXX: For F = 1 To O: If AA = F Then Color C, D: Print OO$(F); Else If OO(F) = 0 Then Color COLOR_ZZ, B: Print O$(F) Else Color A, B: Print O$(F);
10240 XXX = XXX + Len(O$(F)) + 3: Locate Y1, XXX: Next
10250 For F = 1 To O: O$(F) = "": OO(F) = 0: Next: O$ = "": GoSub 7330
Return

10260 Rem
10270 Rem Capitalizing
10280 OO$(FF) = O$(FF): OO = Len(OO$(FF)): For F = 1 To OO: KEY_PRESSED$ = Right$(OO$(FF), F): If Asc(KEY_PRESSED$) >= 97 And Asc(KEY_PRESSED$) <= 122 Then OO$(FF) = Left$(OO$(FF), (OO - F)) + Chr$(Asc(KEY_PRESSED$) - 32) + Right$(KEY_PRESSED$, F - 1)
10290 Next F
Return

10300 Rem
10310 Rem PAUSE
10320 For W = 1 To PAUSE_SECS
    KEY_PRESSED$ = Time$
    While KEY_PRESSED$ = Time$
        If Len(InKey$) Then GoSub 10350: Exit For
    Wend
Next W
10330 Return

10340 Rem
10350 Rem TURN AUTOMATIC KEYBOARD OFF
10360 AUTOKYBD = 0: GoSub 11610
Return

10370 Rem
10380 Rem TURN AUTOMATIC KEYBOARD ON
10390 AUTOKYBD = 1: GoSub 11610
Return

10400 Rem
10410 Rem `other' menu
10420 O$ = "": O$(1) = "see": O$(2) = "file": O$(3) = "options": O$(4) = "defaults": O = 4
10430 GoSub 10000
10440 On AA + 1 GOTO 1940, 3910, 10650, 10830, 10720
10450 GoSub 10380: GoTo 1940
10460 Rem
10470 Rem SET NUMBER OF PLAYERS
10480 Color 7, 0: Locate B1 + 1, L2 + 2: Print Using "Enter number of players [1-#]"; MAX_PLAYERS
10490 GoSub 11350: If INK$ = Chr$(27) Then GoSub 7330: GoTo 10830
10500 If INK > MAX_PLAYERS Or INK < 1 Then GoSub 11280: GoTo 10490
10510 GoSub 7330: Color 7, 0: Locate B1 + 1, L2 + 12: Print Using "# Players"; INK
10520 GoSub 10310: GoSub 7330
10530 If NUM_OF_PLAYERS = INK GoTo 10410 Else If INK > NUM_OF_PLAYERS Then 10550
10540 For L = NUM_OF_PLAYERS To INK + 1 Step -1: GoSub 8200: Next L
Rem Clear variables for all players
10550 For L = NUM_OF_PLAYERS + 1 To INK
    GoSub 11410
Next L
10560 NUM_OF_PLAYERS = INK: GoSub 750: SG = 1: FM = 1: GoTo 890
10570 Rem
10580 Rem SET PAUSE VALUE
10590 Color 7, 0: Locate B1 + 1, L2 + 5: Print "Enter Pause value [0-9]";
10600 GoSub 11350: If INK$ = Chr$(27) Then 10620 Else PAUSE_SECS = INK
10610 GoSub 7330: Color 7, 0: Locate B1 + 1, L2 + 8: Print Using "# Second Pauses"; PAUSE_SECS
10620 GoSub 10310: GoSub 7330: GoTo 10720
10630 Rem
10640 Rem files
10650 GoSub 9650: If ED Then End Else If NW Then 10 Else GoTo 10410
10660 Rem delete player
10680 GoSub 12161: If EPN = 0 Then 10830
10700 L = EPN: GoSub 8160: If AA = 1 Then GoSub 750: SG = 1: FM = 1: GoTo 890 Else GoTo 10830
10710 Rem
10720 Rem `defaults' menu
10730 O$ = "": OO(0) = 1: O$(1) = "pause(" + Right$(Str$(PAUSE_SECS), 1) + ")": O$(2) = "auto": O = 4: OO(1) = 1: OO(3) = 1: OO(4) = 1: If PLAYER_OWES_MONEY_STATUS = 0 Then OO(2) = 1 Else OO(2) = 0
10740 If SOUNDS Then O$(3) = "sound(on)" Else O$(3) = "sound(off)"
10750 If COLOR_ZZ = 7 Then O$(4) = "monitor(monochrome)" Else O$(4) = "monitor(color)"
10760 GoSub 9960: On AA + 1 GOTO 10410, 10580, 10450, 10870, 10770
10770 Rem
10780 Rem change monitor
10790 Color 7, 0: Locate B1 + 1, L2 + 7: If COLOR_ZZ = 7 Then Print "  Color Monitor   ": COLOR_ZZ = 8 Else Print "Monochrome Monitor": COLOR_ZZ = 7
10800 PROPERTY_FOREGROUND_COLOR(12) = COLOR_ZZ: PROPERTY_FOREGROUND_COLOR(28) = COLOR_ZZ: PROPERTY_FOREGROUND_COLOR(4) = COLOR_ZZ
10810 GoSub 10300: GoSub 7330: GoSub 750: SG = 1: FM = 1: GoTo 890
10820 Rem
10830 Rem `options' menu
10840 O$ = "": O$(1) = "players": O$(2) = "delete": O$(3) = "token": O$(4) = "name": O = 4: OO(0) = 1: OO(1) = 1: OO(3) = 1: OO(4) = 1: If NUM_OF_PLAYERS > 1 Then OO(2) = 1 Else OO(2) = 0
10850 GoSub 9960: On AA + 1 GOTO 10410, 10460, 10660, 10860, 12140
10860 GoSub 170: If AA = 1 Then GoSub 750: SG = 1: FM = 1: GoTo 890 Else GoTo 10830
10870 GoSub 11240: GoTo 10720
10880 Rem
10890 Rem property symbols
10900 Rem
10910 MPC = COLOR_ZZ - PROPERTY_M(BP)
10920 If PROPERTY_TYPE(BP) < 2 Then 10990
10930 If BF Then Color 0, 0: Print Space$((BF - (Len(PROPERTY_SHORT_NAMES$(BP)) + 2)) / 2);
10940 If PROPERTY_GROUP_NUM(BP) > 8 Then 10960 Else Color PROPERTY_FOREGROUND_COLOR(BP), PROPERTY_BACKGROUND_COLOR(BP)
10950 Print "±";: Color MPC, 0: Print PROPERTY_SHORT_NAMES$(BP);: Color PROPERTY_FOREGROUND_COLOR(BP), PROPERTY_BACKGROUND_COLOR(BP): Print "±";: GoTo 10970
10960 CR$ = Chr$(219 + 131 * (PROPERTY_GROUP_NUM(BP) = 9)): Color 7, 0: Print CR$;: Color MPC, 0: Print PROPERTY_SHORT_NAMES$(BP);: Color 7, 0: Print CR$;
10970 If BF Then Color 0, 0: Print Space$((BF - (Len(PROPERTY_SHORT_NAMES$(BP)) + 2)) / 2);
10980 GoTo 11020
10990 If BF Then Color 0, 0: Print Space$((BF - Len(PROPERTY_SHORT_NAMES$(BP))) / 2);
11000 If PROPERTY_GROUP_NUM(BP) = 10 Then Color MPC, 0 Else Color PROPERTY_FOREGROUND_COLOR(BP), 0
11010 Print PROPERTY_SHORT_NAMES$(BP);: If BF Then Color 0, 0: Print Space$((BF - Len(PROPERTY_SHORT_NAMES$(BP))) / 2);
11020 Return
11030 Rem
11040 Rem show houses
11050 Color 2, 0: On CU(BP) + 1 GOTO 11110, 11060, 11070, 11080, 11090, 11100
11060 Print "   ";: GoTo 11120
11070 Print "  ";: GoTo 11120
11080 Print " ";: GoTo 11120
11090 Print "";: GoTo 11120
11100 Color 4, 0: Print "   ";: GoTo 11120
11110 Print "    ";
11120 Return
11130 Rem
11140 Rem color/erase chance/chest card area
11150 For A = T3 To B3: Locate A, L2 + 1: Print Space$(32): Next A: Return
11160 Rem
11170 Rem hidden input
11180 KEY_PRESSED$ = InKey$: If Len(KEY_PRESSED$) Then GoSub 10350
11190 If KEY_PRESSED$ <> Chr$(8) Then IP = 0: GoTo 11230
11200 INK = 0: For F = 1 To IP
    11210 KEY_PRESSED$ = InKey$: If Val(KEY_PRESSED$) Or KEY_PRESSED$ = "0" Then INK = INK + Val(KEY_PRESSED$) Else GoTo 11210
11220 Next F
11230 Return
11240 Rem sound on/off
11250 Color 7, 0: Locate T4, L2 + 10: If SOUNDS Then SOUNDS = 0: Print "Sound Off" Else SOUNDS = 1: Print "Sound On"
11260 GoSub 10300: GoSub 7330
11270 Return
11280 Rem beeps
11290 If SOUNDS Then Beep
11300 Return
11310 Rem
11320 Rem put back bottom of board
11330 Color COLOR_ZZ, 0: Locate T1 + 5, L1: Print "»ÕÕÕÕÕÕÕÕÕœÕÕÕÕÕœÕÕÕÕÕœÕÕÕÕÕœÕÕÕÕÕœÕÕÕÕÕœÕÕÕÕÕœÕÕÕÕÕœÕÕÕÕÕœÕÕÕÕÕœÕÕÕÕÕÕÕÕÕº": Return
11340 Rem
11350 Rem GET NUMBER
11360 INK$ = InKey$: If Len(INK$) = 0 Then 11360
11370 If Len(INK$) <> 1 Then GoSub 11280: GoTo 11360 Else If INK$ = Chr$(27) Then INK = 0: Return
11380 If (Val(INK$) Or INK$ = "0") Then INK = Val(INK$) Else GoSub 11280: GoTo 11360
11390 Return
11400 Rem
11410 Rem CLEAR A NEW PLAYER'S VARIABLES
11420 TP(PLAYER_MAP(L)) = 0
RTP(PLAYER_MAP(L)) = 0
PLAYER_CURRENT_PROPERTY(PLAYER_MAP(L)) = 0
X(1, PLAYER_MAP(L)) = R1 - 5 + L
Y(PLAYER_MAP(L)) = T1 + 4
PLAYER_CASH(PLAYER_MAP(L)) = 1500
Return

11430 Rem
11440 Rem IF PLAYER_OWES_MONEY_STATUS IN A LOADED GAME GO TO CORRECT NEED-MONEY ROUTINE TO PAY DEPT
11450 If PLAYY = 1 Or PLAYY = 2 Then SC = PLAYY: GoSub 7460: GoTo 11490
11460 If PLAYY = 8 Then RL = 0: P1 = CURRENT_PROPERTY_NUM: GoSub 5020: RL = 1: GoSub 5020: GoTo 11490
11470 If PLAYY = 9 Then 5800
11480 If PLAYY = 11 Then SC = 1: GoSub 7460: GoSub 10310: GoSub 7060: GoTo 5800
11490 On PLAYER_OWES_MONEY_STATUS GOTO 6050, 1280, 11500, 2220, 11510
11500 GoSub 6660
GoTo 7010
11510 If TRANSACTION_ALL_PLAYERS_FLAG Then GoSub 6640 Else GoSub 6700
GoTo 7010

11520 Rem
11530 Rem HIGHLIGHT/NORMALIZE `DOUBLES' AT TOP OF BOARD
11540 Locate T1, L1 + 11: Color COLOR_ZZ, 0: Print "[";
If DOUBLES_IN_ROW_COUNT Then Color 14, 1: Print "DOUBLES"; Else Print "doubles";
11550 Color COLOR_ZZ, 0: Print "]"
Return
11560 Rem
11570 Rem HIGHLIGHT/NORMALIZE `DOUBLE RENT' AT TOP OF BOARD
11580 Locate T1, R1 - 23: Color COLOR_ZZ, 0: Print "[";: If PT_FLAG Then Color 14, 1: Print "DOUBLE RENT"; Else Print "double rent";
11590 Color COLOR_ZZ, 0: Print "]";: Return
11600 Rem
11610 Rem HIGHLIGHT/NORMALIZE AUTO KEYBOARD
11620 Locate T1, L1 + 32: Color COLOR_ZZ, 0: Print "[";: If AUTOKYBD Then Color 14, 1: Print "AUTOMATIC"; Else Print "automatic";
11630 Color COLOR_ZZ, 0: Print "]";: Return

11640 Rem
11650 Rem part one of deal menu
11660 If PLAYER_OWES_MONEY_STATUS Then If PLAYER_CASH(PLAYER_MAP(PLAYER_PL1)) >= DUE Then PLAYER_PL = PLAYER_PL1: GoSub 7330: PLAYER_OWES_MONEY_STATUS = 0: GoSub 11320: Return Else PLAYER_PL = PLAYER_PL1
11670 TRADING_PLAYER_A = PLAYER_PL: GoSub 12120
11680 O$ = "": O$(1) = "property": O$(2) = "cards": O$(3) = "money": O$(5) = "bail": O = 5: OO(0) = 1: If PLAYER_P(PLAYER_MAP(PLAYER_PL)) = 0 Then OO(1) = 0 Else OO(1) = 1
11690 If FJ(PLAYER_MAP(PLAYER_PL)) > 0 And NUM_OF_PLAYERS > 1 Then OO(2) = 1 Else OO(2) = 0
11700 If PLAYER_CASH(PLAYER_MAP(PLAYER_PL)) > 0 And NUM_OF_PLAYERS > 1 Then OO(3) = 1 Else OO(3) = 0
11710 If NUM_OF_PLAYERS > 2 Then OO(4) = 1 Else OO(4) = 0
11720 If J(PLAYER_MAP(PLAYER_PL)) = 0 Or PLAYER_OWES_MONEY_STATUS = 4 Then OO(5) = 0 Else OO(5) = 1
11730 O$(4) = "receiver(" + Right$(Str$(TRADING_PLAYER_B), 1) + ")": GoSub 9940: On AA + 1 GOTO 11750, 2310, 11770, 11970, 11740, 2160
11740 GoSub 11910: GoTo 11680
11750 GoTo 1940

11760 Rem
11770 Rem trade cards
11780 O$ = "": OO(0) = 1: O$(1) = "chance": O$(2) = "community chest": O$(3) = "receiver(" + Right$(Str$(TRADING_PLAYER_B), 1) + ")": O = 3: If J1 = PLAYER_MAP(PLAYER_PL) Then OO(1) = 1 Else OO(1) = 0
11790 If J2 = PLAYER_MAP(PLAYER_PL) Then OO(2) = 1 Else OO(2) = 0
11791 If NUM_OF_PLAYERS > 2 Then OO(3) = 1 Else OO(3) = 0
11800 GoSub 9940: CARD = AA: If AA = 3 Then GoSub 11910: GoTo 11770 Else If AA = 0 Then 11680
11810 O$ = "": O$(1) = "sell": O$(2) = "give": O$(3) = "receiver(" + Right$(Str$(TRADING_PLAYER_B), 1) + ")": O = 3: OO(1) = Abs((PLAYER_CASH(PLAYER_MAP(TRADING_PLAYER_B)) > 0)): OO(2) = 1: If NUM_OF_PLAYERS > 2 Then OO(3) = 1 Else OO(3) = 0
11820 GoSub 9940: If AA = 3 Then GoSub 11910: GoTo 11770 Else If AA = 0 Then 11780
11830 If AA = 2 Then 11870
11840 K$ = "": KYT$ = "Sell for:": KYL = 7: KYTF = PLAYER_COLOR(PLAYER_MAP(PLAYER_PL)): KYF = 14: KYB = 1: KYFSTR$ = "\     \": KYA = 2: KYY = B1 + 1: GoSub 9100
11850 If KY$ = Chr$(27) Or Val(K$) = 0 Then 11810 Else If Val(K$) > PLAYER_CASH(PLAYER_MAP(TRADING_PLAYER_B)) Then GoSub 11280: GoTo 11840
11860 PLAYER1_DUE = Val(K$): PLAYER2_DUE = -Val(K$): TRANSACTION_PLAYER_A = TRADING_PLAYER_A: TRANSACTION_PLAYER_B = TRADING_PLAYER_B: GoSub 6590
11870 FJ(PLAYER_MAP(TRADING_PLAYER_A)) = FJ(PLAYER_MAP(TRADING_PLAYER_A)) - 1: FJ(PLAYER_MAP(TRADING_PLAYER_B)) = FJ(PLAYER_MAP(TRADING_PLAYER_B)) + 1: If CARD = 1 Then J1 = PLAYER_MAP(TRADING_PLAYER_B) Else J2 = PLAYER_MAP(TRADING_PLAYER_B)
11880 L = PLAYER_PL: GoSub 1550: L = TRADING_PLAYER_B: GoSub 1550
11890 If PLAYER_OWES_MONEY_STATUS = 0 Then 1940 Else GoTo 11650

11900 Rem
11910 Rem change receiver
11920 Color PLAYER_COLOR(PLAYER_MAP(TRADING_PLAYER_A)), 0: Locate B1 + 1, L2 + 3: Print Using "Enter player number [1-#]"; NUM_OF_PLAYERS
11930 KEY_PRESSED$ = InKey$: If Len(KEY_PRESSED$) = 0 Then 11930
11940 If Len(KEY_PRESSED$) <> 1 Then GoSub 11280: GoTo 11930 Else If KEY_PRESSED$ = Chr$(27) Then GoSub 7330: Return
11950 If Val(KEY_PRESSED$) > 0 And Val(KEY_PRESSED$) <= NUM_OF_PLAYERS And Val(KEY_PRESSED$) <> TRADING_PLAYER_A Then TRADING_PLAYER_B = Val(KEY_PRESSED$) Else GoSub 11280: GoTo 11930
11960 GoSub 7330: Return

11970 Rem
11980 Rem TRANFER FUNDS OVER TO ANOTHER PLAYER
11990 K$ = "": KYT$ = "Amount to trade:": KYL = 7: KYTF = PLAYER_COLOR(PLAYER_MAP(PLAYER_PL)): KYF = 14: KYB = 1: KYFSTR$ = "\     \": KYA = 2: KYY = B1 + 1: GoSub 9100: If KY$ = Chr$(27) Or Val(K$) = 0 Then 11680
12000 If Val(K$) > PLAYER_CASH(PLAYER_MAP(TRADING_PLAYER_A)) Then GoSub 11280: GoTo 11990
12010 PLAYER1_DUE = -Val(K$): PLAYER2_DUE = Val(K$): TRANSACTION_PLAYER_B = TRADING_PLAYER_B: TRANSACTION_PLAYER_A = PLAYER_PL: GoSub 6590: If PLAYER_OWES_MONEY_STATUS = 0 Then 1940 Else GoTo 11650

12020 Rem
12030 Rem Show unowned properties
12040 Locate B2 + 1, L2 + 3
12050 For UOP = 1 To 39: If PROPERTY_TYPE(UOP) < 2 Then 12100
    12060 If PROPERTY_OWNER(UOP) Then Color PLAYER_COLOR(PROPERTY_OWNER(UOP)), 0: Print Chr$(22);: GoTo 12100
    12070 If PROPERTY_GROUP_NUM(UOP) = 10 Then Color 7, 0: Print "€";: GoTo 12100
    12080 If PROPERTY_GROUP_NUM(UOP) = 9 Then Color 7, 0: Print "X";: GoTo 12100
    12090 Color PROPERTY_FOREGROUND_COLOR(UOP), PROPERTY_BACKGROUND_COLOR(UOP): Print "±";
12100 Next UOP
Return

12110 Rem
12120 Rem CHECK TRADING_PLAYER_B
12121 If NUM_OF_PLAYERS = 1 Then TRADING_PLAYER_B = TRADING_PLAYER_A Else If TRADING_PLAYER_B = 0 Or TRADING_PLAYER_B = NUM_OF_PLAYERS + 1 Or TRADING_PLAYER_B = TRADING_PLAYER_A Then TRADING_PLAYER_B = TRADING_PLAYER_A + 1: If TRADING_PLAYER_B > NUM_OF_PLAYERS Then TRADING_PLAYER_B = 1
12122 Return
12123 Rem CALCULATE TRADING_PLAYER_B in PLAYER_OWES_MONEY_STATUS
12124 If PLAYER_OWES_MONEY_STATUS = 3 Or PLAYER_OWES_MONEY_STATUS = 5 And PLAYER2_DUE_TMP <> 0 Then TRADING_PLAYER_B = PL2
12125 Return
12130 Rem
12140 Rem change player's name
12141 GoSub 12162: L = EPN: If L = 0 Then 10830
12150 K$ = J$(PLAYER_MAP(L)): KYT$ = "Player " + Right$(Str$(L), 1) + "'s name:": KYL = 9: KYTF = 7: KYF = 14: KYB = 1: KYFSTR$ = "\       \": KYA = 1: KYY = B1 + 1: GoSub 9100
12160 If KY$ = Chr$(27) Then 10830 Else GoSub 9500: J$(PLAYER_MAP(L)) = K$: GoSub 1510: GoTo 10830
12161 Rem
12162 Rem Enter player num
12170 Color 7, 0: Locate B1 + 1, L2 + 2: Print Using "Enter Player's Number [1-#]"; NUM_OF_PLAYERS
12180 EP$ = InKey$: If Len(EP$) <> 1 Then 12180
12190 If EP$ = Chr$(27) Then EPN = 0: GoSub 7330: Return Else EPN = Val(EP$)
12200 If EPN > 0 And EPN <= NUM_OF_PLAYERS Then GoSub 7330: Return Else GoSub 11280: GoTo 12180
