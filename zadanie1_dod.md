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

## Budowa obrazu wieloarchitekturowego z wykorzystaniem SSH Mount i eksportem Cache
```
docker buildx build --platform linux/amd64,linux/arm64 -t docker.io/mitka7/pawcho-zadanie1:lab8 --ssh default=$HOME/.ssh/gh_lab666_ed25 --push --cache-to type=registry,ref=mitka7/pawcho-zadanie1:cache,mode=max --cache-from type=registry,ref=mitka7/pawcho-zadanie1:cache .

```
<img width="632" height="1060" alt="image" src="https://github.com/user-attachments/assets/e6ea42b0-44fd-4d01-bb3f-00d742cf4f62" />

Główny etap realizacji zadania, polegający na jednoczesnym przygotowaniu obrazów dla architektur linux/amd64 oraz linux/arm64. W procesie wykorzystano zaawansowaną funkcję --mount=type=ssh, która pozwala na bezpieczne klonowanie prywatnego repozytorium GitHub wewnątrz kontenera budującego, bez kopiowania kluczy SSH do warstw obrazu. Skonfigurowano również zewnętrzny backend pamięci podręcznej (cache) w trybie max, co umożliwia przechowywanie kompletnego stanu środowiska kompilacji skrośnej bezpośrednio w rejestrze Docker Hub.

## Weryfikacja struktury manifestu wieloarchitekturowego
```
docker buildx imagetools inspect mitka7/pawcho-zadanie1:lab8
```
<img width="933" height="585" alt="image" src="https://github.com/user-attachments/assets/7ae25111-fa32-4e8c-8059-d123d99053cd" />

Wykorzystanie narzędzia docker buildx imagetools inspect w celu potwierdzenia poprawnej publikacji obrazu. Polecenie to weryfikuje tzw. Manifest List, czyli strukturę, która informuje klienta o dostępności różnych wersji binarnych pod jednym wspólnym tagiem. Wynik polecenia stanowi dowód na to, że obraz jest gotowy do uruchomienia zarówno na tradycyjnych serwerach x86, jak i na energooszczędnych układach ARM64.

## Test efektywności mechanizmu Cache (Ponowne budowanie)
```
docker buildx build --platform linux/amd64,linux/arm64 -t docker.io/mitka7/pawcho-zadanie1:lab8 --ssh default=$HOME/.ssh/gh_lab666_ed25 --push --cache-to type=registry,ref=mitka7/pawcho-zadanie1:cache,mode=max --cache-from type=registry,ref=mitka7/pawcho-zadanie1:cache .
```

<img width="628" height="936" alt="image" src="https://github.com/user-attachments/assets/76dbb524-5d65-4495-844b-2ce220025a8f" />

Poprawne wykorzystanie warstw cache zostało zweryfikowane poprzez ponowne uruchomienie procesu budowania. System BuildKit rozpoznał istniejące warstwy w zdalnym rejestrze (importing cache manifest), co pozwoliło na pominięcie powtarzalnych etapów (instalacja narzędzi, kompilacja) i skrócenie czasu budowania z kilku minut do kilkunastu sekund (status CACHED w logach).

