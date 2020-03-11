% @Author: Chen Zhiliang
% @creation date  : 2018/12/16
% @Arrangement : Abdullah �i�ekli
% @School : F�rat �niversitesi Adli Bili�im M�hendisli�i
% @Student ID: 170509051
% @E-mail: abdulahcicekli@gmail.com
% @date of arrangement : 2019/03/11

clc;clear;
close all;
 sayac=1;
%% RES�M ��LEMLER�

%Resmi Okuma
bozukresim = imread('C:\Users\a\Desktop\12.jpg');

%% PARAMETRE AYARLARI
% Parametreleri belirlerken PSF yar��ap�n� odak bulan�kl���na g�re girmemiz
% gerekiyor. Bunun i�in ise deneme yan�lma yolu ile belli bir aral���
% bulabilmek. Biliyorsak a�a��daki parametrede belirtebiliriz. Bilmiyorsak
% a�a��daki parametreleri yorum sat�r�na �evirerek E�ER ile ba�layan yorum
% sat�r�n� a��p bulabiliriz. 


yumusat = 17;    %Yumu�atma 
halkasal = 'On';  % Halkasal Yumu�atma Efekti
yaricap=11.3;

%Resmi Fonksiyona G�nderip D�zeltme
duzeltilmis = mercek_bulanikligi_temizle(bozukresim, yaricap, yumusat, halkasal);
%D�zeltilmi� Resmi ve Orjinal Resmi G�sterme
figure,imshow(cat(2,bozukresim,duzeltilmis)),title('Odak Bulan�kl��� D�zeltme');

%% E�ER YARI�API TAHM�N EDEM�YORSANIZ BU YORUM SATIRINI A�ARAK 10 ARLI KONTROL SA�LAYIP BULAB�L�RS�N�Z
%yaricapp=10; %10-20-30 gibi de�erler yaz�lmal�.
%for i=yaricapp:yaricapp+9
%yaricap = i;  
%yumusat = 17;    
%halkasal = 'On'; 
% duzeltilmis = mercek_bulanikligi_temizle(bozukresim, yaricap, yumusat, halkasal);
% subplot(2,5,sayac),imshow(duzeltilmis) , title(i);
% sayac=sayac+1;
% end

%% Alt Sat�r ��kt�y� Kaydetmek ��indir.
%imwrite(duzeltilmis,['D�zeltilmi� Resim ' num2str(yaricap) ' yar��ap ile ve ' num2str(yumusat) ' yumu�atma ile ' '.png']);


function duzeltilmis = mercek_bulanikligi_temizle(bozukresim, yaricap, yumusat, halkasal)

    % Renkli Resmin T�m Katmanlar�n� D�zeltmek ��in
    if size(bozukresim, 3) == 3
        duzeltilmis = bozukresim;
        for c = 1 : 3
            duzeltilmis(:, :, c) = mercek_bulanikligi_temizle(bozukresim(:, :, c), yaricap, yumusat, halkasal);
        end
    else
        % PSF Olu�turma
        psf = zeros(size(bozukresim, 1), size(bozukresim, 2));
        [rows, cols] = size(psf);
        psf = insertShape(psf, 'FilledCircle', [(cols + 1)/ 2, (rows + 1)/ 2, yaricap], 'Color', 'white', 'Opacity', 1) * 255;      
        psf = psf(:, :, 1);
        psf = psf ./ sum(sum(psf));
        psf = fftshift(psf);
        
        psf_fft = fft2(psf);
        G_fft = fft2(bozukresim);
        
        % Halkasal Yumu�atma A��k �se Yap�lacaklar
        if strcmp(halkasal, 'On')
            for i = 1 : rows
                for j = 1 : cols
                    G_fft(i, j) = G_fft(i, j) * real(psf_fft(i, j));
                end
            end

            tmp = real(ifft2(G_fft));
            for i = 1 : rows
                for j = 1 : cols
                    if (i < yaricap) || (j < yaricap) || (i > rows - yaricap) || (j > cols - yaricap)
                        bozukresim(i, j) = tmp(i, j);% / (rows * cols);
                    end
                end
            end
        end
        
        % wiener filtersi 
        G_fft= fft2(bozukresim);
        K = (1.09 ^ yumusat) / 10000;
        for i = 1 : rows
            for j = 1 : cols
                energyValue = abs(psf_fft(i, j)) ^ 2;
                wienerValue = real(psf_fft(i, j)) / (energyValue + K);
                G_fft(i, j) = wienerValue * G_fft(i, j);
            end
        end
        duzeltilmis = uint8(real(ifft2(G_fft)));
    end
end