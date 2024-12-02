FROM mcr.microsoft.com/windows/servercore:ltsc2022-amd64

RUN powershell -Command \
    Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

RUN choco install -y mingw cmake.portable git
ENV PATH="C:\\ProgramData\\mingw64\\mingw64\\bin;%PATH%"

RUN cmake --version && gcc --version

RUN git clone https://github.com/rlguy/Blender-FLIP-Fluids.git /flop
COPY flop/cmake/CMakeLists.txt /flop/CMakeLists.txt

WORKDIR /flop/build

RUN cmake -G "MinGW Makefiles" ..

CMD ["cmake", "--build", "."]