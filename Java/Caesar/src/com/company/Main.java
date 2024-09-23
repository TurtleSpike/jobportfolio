package com.company;

import static javax.swing.JOptionPane.*;

public class Main {

    public static void main(String[] args) {

        String choice = showInputDialog("Выберите режим: \n 1 - Шифратор \n 2 - Дешифратор \n 3 - Калькулятор");
        int rejim = Integer.parseInt(choice);

        if (rejim == 1) {
            String txt = showInputDialog("Введите шифруемый текст: ");
            String sdwig = showInputDialog("Введите желаемый шаг сдвига: ");
            String text = "";

            int shag = Integer.parseInt(sdwig);
            int size = txt.length();
            int i, k;

            for (i = 1; i <= size; i++) {
                char A = txt.charAt(i - 1);

                if (shag < 0) {
                    for (k = 1; k < -shag; k++) {
                        if (A == 'А' || A == 'а') {
                            A += 31;
                        } else if (A <= 1103 && A>= 1040) {A--;}
                    }
                }
                if (shag > 0) {
                    for (k = 1; k <= shag; k++) {
                        if (A == 'Я' || A == 'я') {
                            A -= 31;
                        } else if (A <= 1103 && A>= 1040) {A++;}
                    }
                }

                text += A;

                if (i == size) {break;}
            }

            showMessageDialog(null, "Введенный текст: " + txt + "\n Итоговый текст: " + text);
        }

        if (rejim == 2) {
            String txt = showInputDialog(null, "Введите дешифрируемый текст: ");
            String sdwig = showInputDialog("Введите шаг сдвига, с помощью которого шифровался текст: ");
            String text = "";
            int shag = Integer.parseInt(sdwig);
            int size = txt.length();
            int i, k;

            for (i = 1; i <= size; i++) {
                char A = txt.charAt(i-1);

                if (shag > 0) {
                    for (k = 1; k <= shag; k++){
                        if (A == 'А' || A == 'а') {
                            A += 31;
                        } else if (A <= 1103 && A>= 1040) {A--;}
                    }
                }
                if (shag < 0) {
                    for (k = 1; k <= -shag; k++){
                        if (A == 'Я' || A == 'я') {
                            A -= 31;
                        } else if (A <= 1103 && A>= 1040) {A++;}
                    }
                }

                text += A;

                if (i == size) {break;}
            }
            showMessageDialog(null, "Введенный текст: " + txt + "\n Итоговый текст: " + text);
        }

        if (rejim == 3) {
            String txt = showInputDialog(null, "Введите желаемый текст: ");
            String text = "";
            String slovo = txt;
            String itogo = "";
            int shag = 1;
            int i;
            char A;
            int size = txt.length();
            for (i = 1; i <= size; i++) {
                A = slovo.charAt(i-1);
                if (A == 'Я' || A == 'я') {
                    A -= 31;
                } else if (A <= 1103 && A>= 1040) {A++;}
                text += A;

                if (i == size) {
                    slovo = text;
                    int r = -32 + shag;
                    itogo += "+" + shag + " (" + r + ") : " + slovo + "\n";
                    i = 0;
                    shag++;
                    text = "";
                }
                if(shag == 32) {break;}
            }
            showMessageDialog(null, "Введенный текст: " + txt + "\n \n" + "Расшифровка: \n +0 : " + txt + "\n" + itogo );
        }
    }
}

