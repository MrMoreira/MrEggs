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

# Função para obter a versão mais recente do wiki.gg
get_latest_version() {
    local page_content=$(curl -sSL "https://terraria.wiki.gg/wiki/Server#Downloads" 2>/dev/null)
    local latest_url=$(echo "${page_content}" | grep -oE 'https://terraria\.org/api/download/pc-dedicated-server/terraria-server-[0-9]+\.zip' | head -1)
    # Extrai apenas o número da versão (ex: 1454)
    echo "${latest_url}" | grep -oE '[0-9]+\.zip' | sed 's/\.zip//'
}

# Função para obter a versão instalada atualmente
get_installed_version() {
    if [ -f "./logs/run.log" ]; then
        grep "Versão Limpa:" ./logs/run.log 2>/dev/null | tail -1 | awk '{print $NF}'
    else
        echo ""
    fi
}

# Função para realizar a atualização
perform_update() {
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    echo -e "${WHITE}🔄  Atualizando Terraria Server...${RESET}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${RESET}"
    
    # Remove os arquivos antigos do servidor
    echo -e "${BLUE}Removendo arquivos antigos...${RESET}"
    rm -f ./TerrariaServer 2>/dev/null
    rm -f ./TerrariaServer.bin.x86_64 2>/dev/null
    rm -f ./TerrariaServer.exe 2>/dev/null
    
    echo -e "${WHITE}✅ Arquivos removidos! Baixando nova versão...${RESET}"
}

# Verifica se o servidor já está instalado
if [ -f "./TerrariaServer.exe" ]; then
    echo -e "${BLUE}Servidor Terraria detectado. Verificando atualizações...${RESET}"
    
    INSTALLED_VERSION=$(get_installed_version)
    LATEST_VERSION=$(get_latest_version)
    
    echo -e "${WHITE}Versão instalada: ${CYAN}${INSTALLED_VERSION:-Desconhecida}${RESET}"
    echo -e "${WHITE}Versão mais recente: ${CYAN}${LATEST_VERSION}${RESET}"
    
    # Se AUTO_UPDATE estiver habilitado e houver versão nova
    if [ "${AUTO_UPDATE}" = "1" ] || [ "${AUTO_UPDATE}" = "true" ]; then
        if [ ! -z "${LATEST_VERSION}" ] && [ "${INSTALLED_VERSION}" != "${LATEST_VERSION}" ]; then
            echo -e "${CYAN}🆕 Nova versão disponível! Iniciando atualização automática...${RESET}"
            perform_update
            # Continua para baixar a nova versão (não executa o else abaixo)
        else
            echo -e "${WHITE}✅ Servidor já está na versão mais recente!${RESET}"
            bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/Terraria/launch.sh)
            exit 0
        fi
    else
        # AUTO_UPDATE desabilitado, apenas inicia o servidor
        bash <(curl -s https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/Terraria/launch.sh)
        exit 0
    fi
fi

# Instalação / Atualização do servidor
if [ ! -f "./TerrariaServer.exe" ]; then

    apk add --no-cache --upgrade curl wget file unzip zip

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
                for ver in 1454 1453 1452 1451 1450 1449 1448 1447 1446 1445 1444; do
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

fi
