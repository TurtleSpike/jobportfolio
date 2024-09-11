package com.company;
import static javax.swing.JOptionPane.*;

public class Main {

    public static void main(String[] args) {

        String rejim = showInputDialog("Выберите режим работы: \n 1- Шифратор \n 2- Дешифратор");

        if (rejim == "1") {
            String txt = showInputDialog("Введите шифруемый текст: ");
            String text = "";
            String key = showInputDialog("Введите ключ-текст, по которому будет выполняться шифровка: ");

            int i, k = 1; //i отвечает за букву фразы , k - за букву ключа
            int x; //x отвечает за количество итераций цикла сдвига
            int shag;
            char A, B;
            int txtsize = txt.length();
            int keysize = key.length();

            if (key.charAt(0) > 1039 && key.charAt(0) < 1072) {
                for (i = 1; i <= txtsize; i++, k++) {
                    if (k <= keysize) {
                        A = txt.charAt(i - 1);
                        B = key.charAt(k - 1);
                        if (A < 1040 || A > 1103) {
                            text += A;
                        } else {
                            while (B > 1103 || B < 1040) {
                            k++;
                            B = key.charAt(k - 1);
                        }
                        shag = B - 1039;

                        for (x = 1; x <= shag; x++) {
                            if (A == 'Я' || A == 'я') {
                                A -= 31;
                            } else if (A <= 1103 && A >= 1040) {
                                A++;
                            }
                        }

                        text += A;

                        if (k == keysize) {
                            k = 1;
                        }
                        if (i == txtsize) {
                            break;
                        }
                    }
                }
                showMessageDialog(null, "Введенный текст: " + txt + "\n Введенный ключ-текст: " + key +
                        "\n \n Полученный текст: " + text); }
            }
        } else if (key.charAt(0) > 64 && key.charAt(0) < 91) {

        }

        if (rejim == "2"){
            String txt = showInputDialog("Введите зашифрованный текст: ");
            String key = showInputDialog("Введите ключ-текст, по которому выполнялась шифровка: ");
            String text = "";
            int i, k = 1; //i отвечает за букву фразы , k - за букву ключа
            int x; //x отвечает за количество итераций цикла сдвига
            int shag;
            char A, B;
            int txtsize = txt.length();
            int keysize = key.length();

            for (i = 1; i <= txtsize; i++, k++) {
                if (k <= keysize) {
                    A = txt.charAt(i - 1);
                    B = key.charAt(k - 1);
                    while (B > 1103 || B < 1040) {
                        k++;
                        B = key.charAt(k-1);
                    }

                    shag = B - 1039;

                    for (x = 1; x <= shag; x++) {
                        if (A == 'А' || A == 'а') {
                            A += 31;
                        } else if (A <= 1103 && A >= 1040) {
                            A--;
                        }
                    }

                    text += A;

                    if (k == keysize) {
                        k = 1;
                    }
                    if (i == txtsize) {
                        break;
                    }
                }
            }
            showMessageDialog(null, "Введенный текст: " + txt + "\n Введенный ключ-текст: " + key +
                    "\n \n Полученная текст: " + text);
        }

        else {showMessageDialog(null, "Введено неверное число или формат текста. Попробуйте еще раз", "Ошибка!", ERROR_MESSAGE);}

        }

    }