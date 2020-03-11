% @Author: Chen Zhiliang
% @creation date  : 2018/12/16
% @Arrangement : Abdullah Çiçekli
% @School : Fýrat Üniversitesi Adli Biliþim Mühendisliði
% @Student ID: 170509051
% @E-mail: abdulahcicekli@gmail.com
% @date of arrangement : 2019/03/11

clc;clear;
close all;
 sayac=1;
%% RESÝM ÝÞLEMLERÝ

%Resmi Okuma
bozukresim = imread('C:\Users\a\Desktop\12.jpg');

%% PARAMETRE AYARLARI
% Parametreleri belirlerken PSF yarýçapýný odak bulanýklýðýna göre girmemiz
% gerekiyor. Bunun için ise deneme yanýlma yolu ile belli bir aralýðý
% bulabilmek. Biliyorsak aþaðýdaki parametrede belirtebiliriz. Bilmiyorsak
% aþaðýdaki parametreleri yorum satýrýna çevirerek EÐER ile baþlayan yorum
% satýrýný açýp bulabiliriz. 


yumusat = 17;    %Yumuþatma 
halkasal = 'On';  % Halkasal Yumuþatma Efekti
yaricap=11.3;

%Resmi Fonksiyona Gönderip Düzeltme
duzeltilmis = mercek_bulanikligi_temizle(bozukresim, yaricap, yumusat, halkasal);
%Düzeltilmiþ Resmi ve Orjinal Resmi Gösterme
figure,imshow(cat(2,bozukresim,duzeltilmis)),title('Odak Bulanýklýðý Düzeltme');

%% EÐER YARIÇAPI TAHMÝN EDEMÝYORSANIZ BU YORUM SATIRINI AÇARAK 10 ARLI KONTROL SAÐLAYIP BULABÝLÝRSÝNÝZ
%yaricapp=10; %10-20-30 gibi deðerler yazýlmalý.
%for i=yaricapp:yaricapp+9
%yaricap = i;  
%yumusat = 17;    
%halkasal = 'On'; 
% duzeltilmis = mercek_bulanikligi_temizle(bozukresim, yaricap, yumusat, halkasal);
% subplot(2,5,sayac),imshow(duzeltilmis) , title(i);
% sayac=sayac+1;
% end

%% Alt Satýr Çýktýyý Kaydetmek Ýçindir.
%imwrite(duzeltilmis,['Düzeltilmiþ Resim ' num2str(yaricap) ' yarýçap ile ve ' num2str(yumusat) ' yumuþatma ile ' '.png']);


function duzeltilmis = mercek_bulanikligi_temizle(bozukresim, yaricap, yumusat, halkasal)

    % Renkli Resmin Tüm Katmanlarýný Düzeltmek Ýçin
    if size(bozukresim, 3) == 3
        duzeltilmis = bozukresim;
        for c = 1 : 3
            duzeltilmis(:, :, c) = mercek_bulanikligi_temizle(bozukresim(:, :, c), yaricap, yumusat, halkasal);
        end
    else
        % PSF Oluþturma
        psf = zeros(size(bozukresim, 1), size(bozukresim, 2));
        [rows, cols] = size(psf);
        psf = insertShape(psf, 'FilledCircle', [(cols + 1)/ 2, (rows + 1)/ 2, yaricap], 'Color', 'white', 'Opacity', 1) * 255;      
        psf = psf(:, :, 1);
        psf = psf ./ sum(sum(psf));
        psf = fftshift(psf);
        
        psf_fft = fft2(psf);
        G_fft = fft2(bozukresim);
        
        % Halkasal Yumuþatma Açýk Ýse Yapýlacaklar
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