# ETAP 1: Środowisko budujące (wykorzystanie Alpine z kompilatorem gcc i biblioteką musl)
FROM alpine:latest AS builder

# Instalacja kompilatora gcc oraz kompresora UPX
RUN apk add --no-cache gcc musl-dev upx

# Katalog roboczy
WORKDIR /app

# Optymalizacja cache: Kopiowanie kodu aplikacji przed kompilacją
COPY server.c .

# Kompilacja i kompresja (jedna zoptymalizowana warstwa)
# -Os: optymalizacja pod rozmiar pliku (wyłącz te optymalizacje, które zwiększają rozmiar pliku)
# -static: statyczne linkowanie (wymóg dla obrazu scratch)
# -ffunction-sections -fdata-sections -Wl,--gc-sections: usuwanie nieużywanego kodu z binarki
# upx --best --lzma: kompresowanie gotowego pliku binarnego do absolutnego minimum
RUN gcc -Os -static -s -ffunction-sections -fdata-sections -Wl,--gc-sections server.c -o server && \
    upx --best --lzma server

# ETAP 2: Docelowy obraz
FROM scratch

# Informacje o autorze zgodne ze standardem OCI
LABEL org.opencontainers.image.authors="Weronika Mitaszka <s101631@pollub.edu.pl>"

# Kopiowanie skompresowanego pliku - jedyna fizyczna warstwa obrazu
COPY --from=builder /app/server /server

# Użytkownik o numerze ID 10001 (nie-root)
USER 10001

# Dokumentacja nasłuchującego portu
EXPOSE 8080/tcp

# Healthcheck. Obraz scratch nie ma shella, stąd wywołanie aplikacji
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
    CMD ["/server", "health"]

# Uruchomienie aplikacji
CMD ["/server"]