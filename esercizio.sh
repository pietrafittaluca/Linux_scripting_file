# Lista alunni (inserisci e poi estrai per interrogare)
# Scrivere uno script che preveda:
#   1 - Inserimento di nome e matricola (opzionale)
#   2 - Estrazione randomica di nome e matricola tenendo conto della precedente estrazione
#       (ad esempio, se le matricole sono 5 ed è già uscita la 3, le prossime estrazioni saranno 1, 2, 3, 5)
#   3 - Cancellazione di una matricola

# ATTENZIONE: per convenzione il file degli alunni conterrà matricola:nome
# dove la matricola sarà del tipo 0001, 0002 ... 000x

# Variabili globali
file_alunni="lista_alunni"
file_occorrenze="occorrenze"
lista_alunni=()
lista_occorrenze=()

# Funzioni
function inizializzazione()
{
    if [ ! -d "files" ]; then
        mkdir files
    fi

    cd files

    if [[ ! -f $file_alunni && ! -f $file_occorrenze ]]; then
        touch $file_alunni
        touch $file_occorrenze
    fi

    return 0
}

function lettura_file()
{
    lista_alunni=()
    lista_occorrenze=()

    i=0
    while read line; do
        lista_alunni[$i]=$line
        ((i++))
    done < $file_alunni

    i=0
    while read line; do
        lista_occorrenze[$i]=$line
        ((i++))
    done < $file_occorrenze

    return 0
}

function inserisci_alunno()
{
    matricola="aaaa"
    while [[ ! $matricola =~ ^[0-9]+$ || ${#matricola} -ne 4 ]];
    do
        read -p "Inserisci la matricola dell'alunno: " matricola
    done
    read -p "Inserisci il nome dell'alunno: " nome

    len=${#lista_alunni[@]}
    for ((i=0; i<len; i++))
    do
        string=${lista_alunni[i]:0:4}
        if [[ $matricola -eq $string ]]; then
            echo "Matricola già presente."
            return -1
        fi
    done

    stringa=$matricola":"$nome
    echo $stringa >> $file_alunni

    return 0
}

function estrai_alunno()
{
    len=${#lista_alunni[@]}
    len_occ=${#lista_occorrenze[@]}

    if [[ $len -eq $len_occ ]]; then
        echo "Sono già stati chiamati tutti gli alunni"
        return -1
    fi

    myrandom=$((0 + $RANDOM % $len))

    if [[ ${#lista_occorrenze[@]} -ne 0 ]]; then        
        mybool=0
        while [[ $mybool -eq 0 ]];
        do
            mybool=1
            for ((i=0; i<len_occ; i++))
            do
                if [[ ${lista_occorrenze[i]} -eq $myrandom ]]; then
                    mybool=0
                    myrandom=$((0 + $RANDOM % $len))
                    break
                fi
            done
        done
    fi

    echo ${lista_alunni[$myrandom]}
    echo $myrandom >> $file_occorrenze

    return 0
}

function cancella_alunno()
{
    matricola="aaaa"
    while [[ ! $matricola =~ ^[0-9]+$ || ${#matricola} -ne 4 ]];
    do
        read -p "Inserisci la matricola dell'alunno: " matricola
    done

    index=-1
    len=${#lista_alunni[@]}
    for ((i=0; i<len; i++))
    do
        string=${lista_alunni[i]:0:4}
        if [[ $matricola -eq $string ]]; then
            index=$i
            echo "Matricola trovata alla posizione $i, $index"
            break
        fi
    done

    if [[ $index -ne -1 ]]; then
        for (( i=0; i<${#lista_alunni[@]}; i++ )); do 
            if [[ $i == $index ]]; then
                lista_alunni=( "${lista_alunni[@]:0:$i}" "${lista_alunni[@]:$((i + 1))}" )
                i=$((i - 1))
            fi
        done

        for (( i=0; i<${#lista_occorrenze[@]}; i++ )); do 
            if [[ ${lista_occorrenze[i]} == $index ]]; then
                lista_occorrenze=( "${lista_occorrenze[@]:0:$i}" "${lista_occorrenze[@]:$((i + 1))}" )
                i=$((i - 1))
            fi
        done

        > $file_alunni
        for (( i=0; i<${#lista_alunni[@]}; i++ )); do 
            echo "${lista_alunni[i]}" >> $file_alunni
        done

        > $file_occorrenze
        for (( i=0; i<${#lista_occorrenze[@]}; i++ )); do 
            echo "${lista_occorrenze[i]}" >> $file_occorrenze
        done
    else
        echo "Matricola non trovata."
    fi

    return 0
}

###########################################################
### MAIN

inizializzazione
lettura_file

### Menù

scelta=-1
while [ $scelta -ne 0 ];
do
    echo "Premere 0 per uscire."
    echo "Premere 1 per Inserire un alunno"
    echo "Premere 2 per Estrarre un alunno"
    echo "Premere 3 per Cancellare un alunno"
    read -p "Inserisci la scelta: " scelta
    clear

    case $scelta in
    0)
        echo "Uscita"
        ;;
    1)
        inserisci_alunno
        lettura_file
        ;;
    2)
        if [[ ${#lista_alunni[@]} -eq 0 ]]; then
            echo "Non ci sono alunni da estrarre."
        else
            estrai_alunno
            lettura_file
        fi
        ;;
    3)
        cancella_alunno
        lettura_file
        ;;
    *)
        echo "Scelta sbagliata"
        ;;
    esac
done
