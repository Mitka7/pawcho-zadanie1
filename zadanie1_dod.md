# Zadanie 1
## Analiza podatności obrazu na zagrożenia

```
docker scout cves p-app-minimal:latest
```

<img width="945" height="391" alt="image" src="https://github.com/user-attachments/assets/3f689a86-52ed-433a-a522-491aba31c02a" />

Przed przystąpieniem do realizacji części rozszerzonej, podstawowy obraz aplikacji został poddany analizie bezpieczeństwa przy użyciu narzędzia Docker Scout. Jak widać na załączonym zrzucie ekranu, skaner nie wykrył żadnych podatności (0 vulnerabilities found). Analiza wykazała zerowy poziom incydentów w kluczowych kategoriach Critical oraz High (0C, 0H), co potwierdza wysoką odporność obrazu na ataki.
Osiągnięcie tak wysokiego poziomu bezpieczeństwa wynika z zastosowania obrazu bazowego scratch oraz procesu statycznej konsolidacji bibliotek (wykorzystanie flagi -static podczas kompilacji kodu źródłowego w języku C). Dzięki temu wynikowy obraz nie zawiera systemu operacyjnego, pakietów systemowych, powłoki (shell) ani bibliotek współdzielonych. Całość środowiska uruchomieniowego stanowi jeden plik binarny, co pozwala na drastyczną minimalizację powierzchni ataku.

## Konfiguracja kluczy SSH

```
eval "$(ssh-agent -s)"
```
```
ssh-add ~/.ssh/gh_lab666_ed25
```
```
ssh-add -l
```

<img width="945" height="249" alt="image" src="https://github.com/user-attachments/assets/091483b8-8d3c-42fc-b11a-fc876294f427" />

Uruchomiono agenta SSH i dodano klucz prywatny do pamięci lokalnej komputera. Dzięki temu mechanizm BuildKit może pobrać kod źródłowy przez SSH, nie zapisując przy tym na stałe żadnych kluczy ani haseł wewnątrz tworzonego kontenera.

## Inicjalizacja lokalnego repozytorium Git

```
git init
```

```
git add server.c Dockerfile
```

```
git commit -m " Dodanie kodu serwera i pliku Dockerfile z części obowiązkowej zadania 1 "
```

```
git branch -M main 
```
<img width="945" height="293" alt="image" src="https://github.com/user-attachments/assets/cf8f8df6-df00-4469-837d-7afc9ec57f49" />

W folderze projektu zainicjowano lokalne repozytorium Git. Do indeksu dodano pliki źródłowe (server.c oraz Dockerfile), a następnie utworzono pierwszy commit (zatwierdzenie zmian). Nazwa głównej gałęzi została ustawiona na main. 

## Publikacja kodu na GitHubie

```
gh auth status
```

```
gh repo create pawcho-zadanie1 --public --source=. --remote=origin –push
```

<img width="945" height="443" alt="image" src="https://github.com/user-attachments/assets/89aee963-e072-4389-9fa7-767e4a7faf72" />

Za pomocą narzędzia GitHub CLI (gh) utworzono publiczne repozytorium zdalne i przesłano do niego lokalne pliki projektu. Operacja ta udostępniła kod źródłowy dla silnika BuildKit, co jest kluczowe dla realizacji mechanizmu mount=type=ssh. Dzięki temu pliki serwera będą pobierane bezpośrednio z GitHuba w trakcie tworzenia obrazu, co zapewnia spójność i automatyzację procesu budowania.

##
```
gh repo create pawcho-zadanie1 --public --source=. --remote=origin –push
```

##
```
gh repo create pawcho-zadanie1 --public --source=. --remote=origin –push
```

##
```
gh repo create pawcho-zadanie1 --public --source=. --remote=origin –push
```


