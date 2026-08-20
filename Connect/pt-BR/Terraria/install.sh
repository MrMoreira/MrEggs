#!/bin/bash
# shellcheck shell=dash

# Cores
BLUE='\033[1;34m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
RESET='\033[0m'

# Banner MrMoreira Hosting
show_banner() {
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                                           ║"
    echo -e "║  ${CYAN}███╗   ███╗${WHITE}██████╗ ${CYAN}███╗   ███╗ ██████╗ ██████╗ ███████╗██╗${WHITE}██████╗ ${CYAN} █████╗ ${BLUE}                  ║"
    echo -e "║  ${CYAN}████╗ ████║${WHITE}██╔══██╗${CYAN}████╗ ████║██╔═══██╗██╔══██╗██╔════╝██║${WHITE}██╔══██╗${CYAN}██╔══██╗${BLUE}                  ║"
    echo -e "║  ${CYAN}██╔████╔██║${WHITE}██████╔╝${CYAN}██╔████╔██║██║   ██║██████╔╝█████╗  ██║${WHITE}██████╔╝${CYAN}███████║${BLUE}                  ║"
    echo -e "║  ${CYAN}██║╚██╔╝██║${WHITE}██╔══██╗${CYAN}██║╚██╔╝██║██║   ██║██╔══██╗██╔══╝  ██║${WHITE}██╔══██╗${CYAN}██╔══██║${BLUE}                  ║"
    echo -e "║  ${CYAN}██║ ╚═╝ ██║${WHITE}██║  ██║${CYAN}██║ ╚═╝ ██║╚██████╔╝██║  ██║███████╗██║${WHITE}██║  ██║${CYAN}██║  ██║${BLUE}                  ║"
    echo -e "║  ${CYAN}╚═╝     ╚═╝${WHITE}╚═╝  ╚═╝${CYAN}╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝${WHITE}╚═╝  ╚═╝${CYAN}╚═╝  ╚═╝${BLUE}                  ║"
    echo "║                                                                                           ║"
    echo -e "║                               ${WHITE}H O S T I N G${BLUE}                                            ║"
    echo "║                                                                                           ║"
    echo "╠═══════════════════════════════════════════════════════════════════════════════════════════╣"
    echo "║                                                                                           ║"
    echo -e "║        ${CYAN}████████╗███████╗██████╗ ██████╗  █████╗ ██████╗ ██╗ █████╗ ${BLUE}                      ║"
    echo -e "║        ${CYAN}╚══██╔══╝██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║██╔══██╗${BLUE}                      ║"
    echo -e "║        ${CYAN}   ██║   █████╗  ██████╔╝██████╔╝███████║██████╔╝██║███████║${BLUE}                      ║"
    echo -e "║        ${CYAN}   ██║   ██╔══╝  ██╔══██╗██╔══██╗██╔══██║██╔══██╗██║██╔══██║${BLUE}                      ║"
    echo -e "║        ${CYAN}   ██║   ███████╗██║  ██║██║  ██║██║  ██║██║  ██║██║██║  ██║${BLUE}                      ║"
    echo -e "║        ${CYAN}   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝${BLUE}                      ║"
    echo "║                                                                                           ║"
    echo "╠═══════════════════════════════════════════════════════════════════════════════════════════╣"
    echo -e "║                        ${WHITE}🌐  https://mrmoreira.com  🌐${BLUE}                                    ║"
    echo "╚═══════════════════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
}

show_banner

# Detecta o diretório de trabalho (instalação vs runtime)
if [ -d "/mnt/server" ]; then
    WORK_DIR="/mnt/server"
else
    WORK_DIR="/home/container"
fi

# Cor adicional
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'

# Função para formatar versão (1454 → 1.4.5.4)
format_version() {
    local ver="$1"
    if [ ${#ver} -eq 4 ]; then
        # 1454 → 1.4.5.4
        echo "${ver:0:1}.${ver:1:1}.${ver:2:1}.${ver:3:1}"
    elif [ ${#ver} -eq 3 ]; then
        # 144 → 1.4.4
        echo "${ver:0:1}.${ver:1:1}.${ver:2:1}"
    elif [ ${#ver} -eq 5 ]; then
        # 14481 → 1.4.4.8.1
        echo "${ver:0:1}.${ver:1:1}.${ver:2:1}.${ver:3:1}.${ver:4:1}"
    else
        echo "$ver"
    fi
}

# Função de loading animado
show_loading() {
    local message="$1"
    local duration="${2:-2}"
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    local end=$((SECONDS + duration))
    
    while [ $SECONDS -lt $end ]; do
        i=$(( (i+1) % ${#spin} ))
        printf "\r${CYAN}${spin:$i:1}${RESET} ${WHITE}${message}${RESET}"
        sleep 0.1
    done
    printf "\r${GREEN}✓${RESET} ${WHITE}${message}${RESET}\n"
}

# Função para barra de progresso
show_progress() {
    local current="$1"
    local total="$2"
    local message="$3"
    local percent=$((current * 100 / total))
    local filled=$((percent / 5))
    local empty=$((20 - filled))
    
    printf "\r${CYAN}[${GREEN}"
    printf "%${filled}s" '' | tr ' ' '█'
    printf "${BLUE}"
    printf "%${empty}s" '' | tr ' ' '░'
    printf "${CYAN}]${RESET} ${WHITE}${percent}%% - ${message}${RESET}"
}

# Função para obter a versão mais recente do wiki.gg
get_latest_version() {
    local page_content=$(curl -sSL "https://terraria.wiki.gg/wiki/Server#Downloads" 2>/dev/null)
    local latest_url=$(echo "${page_content}" | grep -oE 'https://terraria\.org/api/download/pc-dedicated-server/terraria-server-[0-9]+\.zip' | head -1)
    # Extrai apenas o número da versão (ex: 1454)
    echo "${latest_url}" | grep -oE '[0-9]+\.zip' | sed 's/\.zip//'
}

# Função para obter o link de download mais recente
get_latest_download_link() {
    local page_content=$(curl -sSL "https://terraria.wiki.gg/wiki/Server#Downloads" 2>/dev/null)
    echo "${page_content}" | grep -oE 'https://terraria\.org/api/download/pc-dedicated-server/terraria-server-[0-9]+\.zip' | head -1
}

# Função para obter a versão instalada atualmente
get_installed_version() {
    if [ -f "./logs/run.log" ]; then
        grep "Versão Limpa:" ./logs/run.log 2>/dev/null | tail -1 | awk '{print $NF}'
    else
        echo ""
    fi
}

# Função para realizar a atualização (no diretório atual)
perform_update() {
    local download_link="$1"
    local clean_version="$2"
    local formatted_version=$(format_version "$clean_version")
    
    echo ""
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${CYAN}║${RESET}     ${WHITE}🔄  ATUALIZANDO TERRARIA SERVER${RESET}                          ${CYAN}║${RESET}"
    echo -e "${CYAN}║${RESET}     ${CYAN}Nova versão: ${GREEN}${formatted_version}${RESET}                                   ${CYAN}║${RESET}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    
    # Etapa 1: Removendo arquivos antigos
    show_loading "Preparando atualização..." 1
    rm -f ./TerrariaServer 2>/dev/null
    rm -f ./TerrariaServer.bin.x86_64 2>/dev/null
    rm -f ./TerrariaServer.exe 2>/dev/null
    
    # Etapa 2: Baixando nova versão
    echo -e "${CYAN}⬇${RESET}  ${WHITE}Baixando Terraria Server ${GREEN}${formatted_version}${WHITE}...${RESET}"
    curl -sSL "${download_link}" -o terraria-server.zip --progress-bar
    echo -e "${GREEN}✓${RESET}  ${WHITE}Download concluído!${RESET}"
    
    # Etapa 3: Extraindo arquivos
    show_loading "Extraindo arquivos do servidor..." 2
    unzip -o terraria-server.zip >/dev/null 2>&1
    
    # Etapa 4: Instalando arquivos
    show_loading "Instalando novos arquivos..." 1
    cp -R ${clean_version}/Linux/* ./
    
    # Etapa 5: Configurando permissões
    show_loading "Configurando permissões..." 1
    chmod +x TerrariaServer.bin.x86_64 2>/dev/null
    chmod +x TerrariaServer.exe 2>/dev/null
    
    # Etapa 6: Limpando arquivos temporários
    show_loading "Limpando arquivos temporários..." 1
    rm -f terraria-server.zip
    rm -rf ${clean_version}
    rm -f System* 2>/dev/null
    rm -f monoconfig 2>/dev/null
    rm -f Mono* 2>/dev/null
    rm -f mscorlib.dll 2>/dev/null
    
    # Atualiza o log de versão
    mkdir -p logs
    echo "Versão Limpa: ${clean_version}" >> logs/run.log
    
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${GREEN}║${RESET}     ${WHITE}✅  ATUALIZAÇÃO CONCLUÍDA COM SUCESSO!${RESET}                    ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}     ${WHITE}Versão: ${CYAN}${formatted_version}${RESET}                                         ${GREEN}║${RESET}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
}

# Verifica se o servidor já está instalado
if [ -f "./TerrariaServer.exe" ]; then
    echo ""
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BLUE}║${RESET}     ${WHITE}🎮  TERRARIA SERVER DETECTADO${RESET}                             ${BLUE}║${RESET}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════╝${RESET}"
    echo ""

    show_loading "Verificando versões..." 2

    INSTALLED_VERSION=$(get_installed_version)
    INSTALLED_FORMATTED=$(format_version "${INSTALLED_VERSION}")

    # Normaliza a versão definida pelo usuário no painel (remove pontos: 1.4.5.7 -> 1457)
    USER_VERSION_CLEAN=$(echo "${TERRARIA_VERSION}" | sed 's/\.//g')

    echo ""
    echo -e "  ${WHITE}📦 Versão instalada:    ${CYAN}${INSTALLED_FORMATTED:-Desconhecida}${RESET} ${BLUE}(${INSTALLED_VERSION:-?})${RESET}"

    # ─── CASO 1: Usuário definiu versão específica diferente da instalada ───
    if [ ! -z "${TERRARIA_VERSION}" ] \
        && [ "${TERRARIA_VERSION}" != "latest" ] \
        && [ "${USER_VERSION_CLEAN}" != "${INSTALLED_VERSION}" ]; then

        USER_FORMATTED=$(format_version "${USER_VERSION_CLEAN}")
        echo -e "  ${WHITE}🎯 Versão no painel:    ${YELLOW}${USER_FORMATTED}${RESET} ${BLUE}(${USER_VERSION_CLEAN})${RESET}"
        echo ""
        echo -e "  ${YELLOW}⚠️  Versão diferente da instalada! Aplicando versão definida no painel...${RESET}"
        echo ""

        DOWNLOAD_LINK="https://terraria.org/api/download/pc-dedicated-server/terraria-server-${USER_VERSION_CLEAN}.zip"

        if curl --output /dev/null --silent --head --fail "${DOWNLOAD_LINK}" 2>/dev/null; then
            perform_update "${DOWNLOAD_LINK}" "${USER_VERSION_CLEAN}"
        else
            echo -e "  ${RED}❌ Link inválido para versão ${USER_FORMATTED}: ${DOWNLOAD_LINK}${RESET}"
            echo -e "  ${YELLOW}⚠️  Iniciando com a versão instalada...${RESET}"
        fi

        show_loading "Iniciando servidor Terraria..." 2
        bash <(curl -s https://raw.githubusercontent.com/MrMoreira/MrEggs/main/Connect/pt-BR/Terraria/launch.sh)
        exit 0

    # ─── CASO 2: AUTO_UPDATE ativado → verifica versão mais recente no wiki ───
    elif [ "${AUTO_UPDATE}" = "1" ] || [ "${AUTO_UPDATE}" = "true" ]; then
        LATEST_VERSION=$(get_latest_version)
        LATEST_FORMATTED=$(format_version "${LATEST_VERSION}")

        echo -e "  ${WHITE}🆕 Versão mais recente: ${GREEN}${LATEST_FORMATTED}${RESET} ${BLUE}(${LATEST_VERSION})${RESET}"
        echo ""

        if [ ! -z "${LATEST_VERSION}" ] && [ "${INSTALLED_VERSION}" != "${LATEST_VERSION}" ]; then
            echo -e "  ${YELLOW}⚠️  Nova versão disponível! Atualizando...${RESET}"
            echo ""
            DOWNLOAD_LINK=$(get_latest_download_link)
            perform_update "${DOWNLOAD_LINK}" "${LATEST_VERSION}"
        else
            echo -e "  ${GREEN}✅ Servidor já está na versão mais recente!${RESET}"
            echo ""
        fi

        show_loading "Iniciando servidor Terraria..." 2
        bash <(curl -s https://raw.githubusercontent.com/MrMoreira/MrEggs/main/Connect/pt-BR/Terraria/launch.sh)
        exit 0

    # ─── CASO 3: Tudo igual ou auto-update desativado, apenas inicia ───
    else
        LATEST_VERSION=$(get_latest_version)
        LATEST_FORMATTED=$(format_version "${LATEST_VERSION}")
        echo -e "  ${WHITE}🆕 Versão mais recente: ${GREEN}${LATEST_FORMATTED}${RESET} ${BLUE}(${LATEST_VERSION})${RESET}"
        echo ""
        echo -e "  ${CYAN}ℹ️  Atualização automática desativada. Iniciando servidor...${RESET}"
        echo ""
        bash <(curl -s https://raw.githubusercontent.com/MrMoreira/MrEggs/main/Connect/pt-BR/Terraria/launch.sh)
        exit 0
    fi
fi

# Função para reinstalar/reparar o servidor (baixa arquivos sem apagar dados)
repair_server() {
    local download_link="$1"
    local clean_version="$2"
    local formatted_version=$(format_version "$clean_version")
    
    echo ""
    echo -e "${YELLOW}╔═══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${YELLOW}║${RESET}     ${WHITE}🔧  REPARANDO/REINSTALANDO TERRARIA SERVER${RESET}                ${YELLOW}║${RESET}"
    echo -e "${YELLOW}║${RESET}     ${CYAN}Versão: ${GREEN}${formatted_version}${RESET}                                         ${YELLOW}║${RESET}"
    echo -e "${YELLOW}╚═══════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    
    # Etapa 1: Baixando servidor
    echo -e "${CYAN}⬇${RESET}  ${WHITE}Baixando Terraria Server ${GREEN}${formatted_version}${WHITE}...${RESET}"
    curl -sSL "${download_link}" -o terraria-server.zip --progress-bar
    echo -e "${GREEN}✓${RESET}  ${WHITE}Download concluído!${RESET}"
    
    # Etapa 2: Extraindo arquivos
    show_loading "Extraindo arquivos do servidor..." 2
    unzip -o terraria-server.zip >/dev/null 2>&1
    
    # Etapa 3: Instalando arquivos (sem sobrescrever saves e configs existentes)
    show_loading "Instalando arquivos do servidor..." 1
    
    # Copia apenas os arquivos executáveis essenciais
    cp -f ${clean_version}/Linux/TerrariaServer ./TerrariaServer 2>/dev/null
    cp -f ${clean_version}/Linux/TerrariaServer.bin.x86_64 ./TerrariaServer.bin.x86_64 2>/dev/null
    cp -f ${clean_version}/Linux/TerrariaServer.exe ./TerrariaServer.exe 2>/dev/null
    
    # Copia outros arquivos necessários se não existirem
    [ ! -f "./Terraria.png" ] && cp -f ${clean_version}/Linux/Terraria.png ./Terraria.png 2>/dev/null
    [ ! -f "./WindowsBase.dll" ] && cp -f ${clean_version}/Linux/WindowsBase.dll ./WindowsBase.dll 2>/dev/null
    [ ! -f "./FNA.dll" ] && cp -f ${clean_version}/Linux/FNA.dll ./FNA.dll 2>/dev/null
    [ ! -f "./FNA.dll.config" ] && cp -f ${clean_version}/Linux/FNA.dll.config ./FNA.dll.config 2>/dev/null
    [ ! -f "./monomachineconfig" ] && cp -f ${clean_version}/Linux/monomachineconfig ./monomachineconfig 2>/dev/null
    [ ! -f "./changelog.txt" ] && cp -f ${clean_version}/Linux/changelog.txt ./changelog.txt 2>/dev/null
    
    # Etapa 4: Configurando permissões
    show_loading "Configurando permissões..." 1
    chmod +x TerrariaServer 2>/dev/null
    chmod +x TerrariaServer.bin.x86_64 2>/dev/null
    chmod +x TerrariaServer.exe 2>/dev/null
    
    # Etapa 5: Limpando arquivos temporários
    show_loading "Limpando arquivos temporários..." 1
    rm -f terraria-server.zip
    rm -rf ${clean_version}
    
    # Cria diretórios necessários se não existirem
    mkdir -p logs
    mkdir -p saves
    mkdir -p saves/Worlds
    [ ! -f "./banlist.txt" ] && touch banlist.txt
    
    # Atualiza o log de versão
    echo "Versão Limpa: ${clean_version}" >> logs/run.log
    
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${GREEN}║${RESET}     ${WHITE}✅  INSTALAÇÃO/REPARO CONCLUÍDO!${RESET}                         ${GREEN}║${RESET}"
    echo -e "${GREEN}║${RESET}     ${WHITE}Versão: ${CYAN}${formatted_version}${RESET}                                         ${GREEN}║${RESET}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
}

# Verifica se os arquivos essenciais do servidor existem
check_server_files() {
    if [ -f "./TerrariaServer.exe" ] && [ -f "./TerrariaServer.bin.x86_64" ]; then
        return 0  # Arquivos existem
    else
        return 1  # Arquivos faltando
    fi
}

# Instalação/Reinstalação do servidor (quando arquivos estão faltando)
if ! check_server_files; then
    echo ""
    echo -e "${YELLOW}╔═══════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${YELLOW}║${RESET}     ${WHITE}⚠️  ARQUIVOS DO SERVIDOR FALTANDO${RESET}                        ${YELLOW}║${RESET}"
    echo -e "${YELLOW}╚═══════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    
    # Detecta se estamos em contexto de instalação ou start
    if [ -d "/mnt/server" ] && [ -w "/mnt/server" ]; then
        # Contexto de INSTALAÇÃO (Pterodactyl install script)
        echo -e "${BLUE}Contexto: Instalação${RESET}"
        apk add --no-cache --upgrade curl wget file unzip zip 2>/dev/null || true
        mkdir -p /mnt/server/
        cd /mnt/server/ || exit
        mkdir -p logs

    DOWNLOAD_LINK=""
    CLEAN_VERSION=""
    
    # Função para buscar link de download do Fandom Wiki
    get_download_from_fandom() {
        local version="$1"
        if [ "${version}" = "latest" ] || [ "${version}" = "" ]; then
            curl -sSL https://terraria.fandom.com/wiki/Server#Downloads 2>/dev/null | grep '>Terraria Server ' | grep -Eoi '<a [^>]+>' | grep -Eo 'href=\"[^\\\"]+\"' | grep -Eo '(http|https):\/\/[^\"]+' | tail -1 | cut -d'?' -f1
        else
            local clean=$(echo ${version} | sed 's/\.//g')
            curl -sSL https://terraria.fandom.com/wiki/Server#Downloads 2>/dev/null | grep '>Terraria Server ' | grep -Eoi '<a [^>]+>' | grep -Eo 'href=\"[^\\\"]+\"' | grep -Eo '(http|https):\/\/[^\"]+' | grep "${clean}" | cut -d'?' -f1
        fi
    }
    
    # Função para buscar link de download do Wiki.gg
    get_download_from_wikigg() {
        local version="$1"
        local page_content=""
        local download_url=""
        
        # Busca a página de Server do wiki.gg (seção Downloads)
        page_content=$(curl -sSL "https://terraria.wiki.gg/wiki/Server#Downloads" 2>/dev/null)
        
        if [ "${version}" = "latest" ] || [ "${version}" = "" ]; then
            # Pega o primeiro link de download (mais recente)
            download_url=$(echo "${page_content}" | grep -oE 'https://terraria\.org/api/download/pc-dedicated-server/terraria-server-[0-9]+\.zip' | head -1)
        else
            # Busca versão específica
            local clean=$(echo ${version} | sed 's/\.//g')
            download_url=$(echo "${page_content}" | grep -oE "https://terraria\.org/api/download/pc-dedicated-server/terraria-server-${clean}\.zip" | head -1)
        fi
        
        echo "${download_url}"
    }
    
    # Função para verificar se o link é válido
    validate_link() {
        local link="$1"
        if [ ! -z "${link}" ] && [ "${link}" != "invalid" ]; then
            if curl --output /dev/null --silent --head --fail "${link}" 2>/dev/null; then
                echo "valid"
                return 0
            fi
        fi
        echo "invalid"
        return 1
    }
    
    printf "Buscando link de download...\n"
    
    # Tenta primeiro no Wiki.gg (fonte oficial mais atualizada)
    printf "Tentando terraria.wiki.gg...\n"
    DOWNLOAD_LINK=$(get_download_from_wikigg "${TERRARIA_VERSION}")
    
    if [ ! -z "${DOWNLOAD_LINK}" ] && [ "$(validate_link "${DOWNLOAD_LINK}")" = "valid" ]; then
        printf "Link encontrado no Wiki.gg: ${DOWNLOAD_LINK}\n"
    else
        # Fallback 1: tenta no Fandom Wiki
        printf "Wiki.gg falhou, tentando terraria.fandom.com...\n"
        DOWNLOAD_LINK=$(get_download_from_fandom "${TERRARIA_VERSION}")
        
        if [ ! -z "${DOWNLOAD_LINK}" ] && [ "$(validate_link "${DOWNLOAD_LINK}")" = "valid" ]; then
            printf "Link encontrado no Fandom Wiki: ${DOWNLOAD_LINK}\n"
        else
            # Último fallback: tenta diretamente a API oficial do Terraria
            printf "Fandom Wiki falhou, tentando API oficial do Terraria...\n"
            if [ "${TERRARIA_VERSION}" = "latest" ] || [ "${TERRARIA_VERSION}" = "" ]; then
                # Tenta buscar a versão mais recente conhecida
                for ver in 1457 1456 1455 1454 1453 1452 1451 1450 1449 1448 1447 1446 1445 1444; do
                    DOWNLOAD_LINK="https://terraria.org/api/download/pc-dedicated-server/terraria-server-${ver}.zip"
                    if [ "$(validate_link "${DOWNLOAD_LINK}")" = "valid" ]; then
                        printf "Link encontrado na API oficial: ${DOWNLOAD_LINK}\n"
                        break
                    fi
                done
            else
                CLEAN_VERSION=$(echo ${TERRARIA_VERSION} | sed 's/\.//g')
                DOWNLOAD_LINK="https://terraria.org/api/download/pc-dedicated-server/terraria-server-${CLEAN_VERSION}.zip"
            fi
        fi
    fi
    
    # Validação final do link
    if [ -z "${DOWNLOAD_LINK}" ] || [ "$(validate_link "${DOWNLOAD_LINK}")" != "valid" ]; then
        printf "ERRO: Não foi possível encontrar um link de download válido!\n"
        printf "Verifique a versão especificada ou tente novamente mais tarde.\n"
        exit 2
    fi
    
    printf "Link válido encontrado: ${DOWNLOAD_LINK}\n"
    if [ "${TERRARIA_VERSION}" = "1.4.4" ] || [ "${TERRARIA_VERSION}" = "144" ]; then
        CLEAN_VERSION=$(echo ${DOWNLOAD_LINK##*/} | cut -d'-' -f3 | cut -d'.' -f1)
        cat <<EOF >logs/run.log
Atenção, essa versão há um erro GRAVE!!!
Versão: ${TERRARIA_VERSION}
Link: https://terraria.org/api/download/pc-dedicated-server/terraria-server-144.zip
Arquivo: terraria-server-144.zip
Versão Limpa: 144
EOF
        printf "wget https://terraria.org/api/download/pc-dedicated-server/terraria-server-144.zip"
        wget https://terraria.org/api/download/pc-dedicated-server/terraria-server-144.zip
        printf "Unpacking server files"
        unzip -o terraria-server-144.zip
        cp -R 144/Linux/* ./
    else
        CLEAN_VERSION=$(echo ${DOWNLOAD_LINK##*/} | cut -d'-' -f3 | cut -d'.' -f1)
        cat <<EOF >logs/run.log
Versão: ${CLEAN_VERSION}
Link: ${DOWNLOAD_LINK}
Arquivo: ${DOWNLOAD_LINK##*/}
Versão Limpa: ${CLEAN_VERSION}
EOF
        printf "running 'curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}'"
        curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}
        printf "Unpacking server files"
        unzip -o ${DOWNLOAD_LINK##*/}
        cp -R ${CLEAN_VERSION}/Linux/* ./
        mkdir -p saves
        mkdir -p saves/Worlds
    fi
    chmod +x TerrariaServer.bin.x86_64
    chmod +x TerrariaServer.exe
    touch banlist.txt
    printf "Cleaning up extra files."
    rm System*
    rm monoconfig
    rm Mono*
    rm mscorlib.dll
    rm serverconfig.txt
    rm ${DOWNLOAD_LINK##*/}
    rm -r ${CLEAN_VERSION}
    printf "Generating config file"
    cat <<EOF >serverconfig.txt
||----------------------------------------------------------------||
Note: To change any value go to Startup, and change there!
Notas: Para alterar qualquer valor va para Startup, e altere la!
||----------------------------------------------------------------||
world=
worldpath=
modpath=
banlist=
port=
||----------------------------------------------------------------||
worldname=
maxplayers=
difficulty=
autocreate=
slowliquids=
npcstream=
seed=
motd=
||----------------------------------------------------------------||
password=
secure=
language=
EOF

    printf "Install complete."

    else
        # Contexto de START (servidor já rodando, arquivos faltando)
        echo -e "${BLUE}Contexto: Reparo (arquivos do servidor faltando)${RESET}"
        
        show_loading "Buscando versão mais recente..." 2
        
        LATEST_VERSION=$(get_latest_version)
        DOWNLOAD_LINK=$(get_latest_download_link)
        
        if [ ! -z "${DOWNLOAD_LINK}" ] && [ ! -z "${LATEST_VERSION}" ]; then
            echo -e "${WHITE}Versão encontrada: ${GREEN}$(format_version ${LATEST_VERSION})${RESET}"
            repair_server "${DOWNLOAD_LINK}" "${LATEST_VERSION}"
            
            # Após reparar, inicia o servidor
            show_loading "Iniciando servidor Terraria..." 2
            bash <(curl -s https://raw.githubusercontent.com/MrMoreira/MrEggs/main/Connect/pt-BR/Terraria/launch.sh)
        else
            echo -e "${RED}ERRO: Não foi possível encontrar link de download!${RESET}"
            exit 1
        fi
    fi
fi
