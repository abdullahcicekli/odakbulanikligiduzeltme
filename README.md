# Odak Bulanıklığı Düzeltme
Odak Bulanıklığı Azaltma kodu daha önce yayınlayan Chen Zhiliang'in kodunun Türkçeleştirilmiş ve düzenlenmiş halidir.

Deneme Yapmak İçin 12.jpg dosyasını indirip aşağıyı okuyarak kullanımı daha rahat öğrenebilirsiniz.

![Ekran Alıntısı](https://user-images.githubusercontent.com/48344066/76455943-54d40e00-63e7-11ea-96ea-a5f2d6a4b33a.PNG)

# Kullanımı

1- mercekbulanikligi.m dosyasını indirin ve matlab ile çalıştırın.

2- Resim Okuma kısmına bozulmuş görüntünüzün dosya yolunu belirtin.

3- Parametre ayarlarına açıklamalardaki değerleri değiştirin ve kodu çalıştırın.

# Uygulama Örneği

![12](https://user-images.githubusercontent.com/48344066/76456384-f52a3280-63e7-11ea-8ac0-69658c194d2f.jpg)

Resmi incelediğimiz zaman bulanıklığın hareketsel değil odaksal bir bulanıklık olduğunu tespit ediyoruz. Ardından PSF için yarıçap belirlemeye çalışıyoruz. Bunun için deneme yanılma ile veya kod içerisindeki yorum satırı devreye sokarak 10 ar 10 ar kontrol ederek en iyi değeri bulduruyoruz.

![kactane](https://user-images.githubusercontent.com/48344066/76456850-c791b900-63e8-11ea-89bb-16bfcfa5bba4.PNG)

Yukarıdaki resimde 10-20 arasındaki değerleri kodumuza hesaplattıktan sonra en iyi değerin 11 ve 12 olduğunu görmüş oluyoruz. Ve ardından 11-12 arasındaki küsüratlı sayıları 0.1'lik dilimlerle deneyip yine bu aralıktaki en iyi değeri aşağıdaki gibi buluyoruz.

![Düzeltilmiş Resim 11 2 yarıçap ile ve 17 yumuşatma ile ](https://user-images.githubusercontent.com/48344066/76457094-3111c780-63e9-11ea-886d-15db92a6e98a.png)


