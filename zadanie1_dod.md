# Zadanie 1
## Analiza podatności obrazu na zagrożenia

```
docker scout cves p-app-minimal:latest
```

<img width="945" height="391" alt="image" src="https://github.com/user-attachments/assets/3f689a86-52ed-433a-a522-491aba31c02a" />

Przed przystąpieniem do realizacji części rozszerzonej, podstawowy obraz aplikacji został poddany analizie bezpieczeństwa przy użyciu narzędzia Docker Scout. Jak widać na załączonym zrzucie ekranu, skaner nie wykrył żadnych podatności (0 vulnerabilities found). Analiza wykazała zerowy poziom incydentów w kluczowych kategoriach Critical oraz High (0C, 0H), co potwierdza wysoką odporność obrazu na ataki.
Osiągnięcie tak wysokiego poziomu bezpieczeństwa wynika z zastosowania obrazu bazowego scratch oraz procesu statycznej konsolidacji bibliotek (wykorzystanie flagi -static podczas kompilacji kodu źródłowego w języku C). Dzięki temu wynikowy obraz nie zawiera systemu operacyjnego, pakietów systemowych, powłoki (shell) ani bibliotek współdzielonych. Całość środowiska uruchomieniowego stanowi jeden plik binarny, co pozwala na drastyczną minimalizację powierzchni ataku.




```
docker scout cves p-app-minimal:latest
```

```
docker scout cves p-app-minimal:latest
```

```
docker scout cves p-app-minimal:latest
```

```
docker scout cves p-app-minimal:latest
```

```
docker scout cves p-app-minimal:latest
```
