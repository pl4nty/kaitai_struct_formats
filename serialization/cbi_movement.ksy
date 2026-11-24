# Imported from https://github.com/simonmx1/CBI_Parser/blob/14401f46970545ab5c1c97d95f449f66f357a6a8/src/parse/cbi.ksy
# Licence and copyright: see _community/README.md
meta:
  id: cbi_movement
  title: cbi movement
  file-extension: txt
  license: CC0-1.0
  encoding: UTF-8
  endian: le
doc-ref: https://www.cbi-org.eu/


seq:
  - id: record
    size: 122
    type: record
    repeat: eos


types:
  record:
    seq:
      - id: separator
        size: 1
        contents: " "
      - id: tipo_record
        size: 2
        type: str
        doc: Contiene il tipo die Documento CBI
      - id: content
        type:
          switch-on: tipo_record
          cases:
            '"RH"': record_testa
            '"EC"': record_testa
            '"EF"': record_coda
            '"61"': saldo_inziale
            '"62"': movimento
            '"63"': inf_movimento
            '"64"': saldo_finale
            '"65"': liquidita_future
            _: undefined
        doc: Tutti i record nel documento CBI incl. saldi


  undefined: {}
  
  
  record_testa:
    seq:
      - id: mittente
        size: 5
        type: str
        doc: codice ABI della Banca mittente degli estratti conto
      - id: ricevente
        size: 5
        type: str
        doc: codice SIA dell'Impresa destinataria della rendicontazione conti correnti
      - id: data_creazione
        size: 6
        type: str
        doc: data di creazione del flusso da parte della Banca
      - id: nome_supporto
        size: 20
        type: str
        doc: campo di libera composizione da parte della Banca Mittente
      - id: filler
        size: 76
      - id: non_disponibile
        size: 5

  record_coda:
    seq:
      - id: mittente
        size: 5
        type: str
        doc: codice ABI della Banca mittente degli estratti conto
      - id: ricevente
        size: 5
        type: str
        doc: codice SIA dell'Impresa destinataria della rendicontazione conti correnti
      - id: data_creazione
        size: 6
        type: str
        doc: data di creazione del flusso da parte della Banca
      - id: nome_supporto
        size: 20
        type: str
        doc: campo di libera composizione da parte della Banca Mittente
      - id: filler1
        size: 6
      - id: numero_rendicontazioni
        size: 7
        type: str
        doc: totale delle rendicontazioni di conto corrente contenute nel flusso
      - id: filler2
        size: 30
      - id: numero_record
        size: 7
        doc: numero dei record che compongono il flusso
      - id: filler3
        size: 25
      - id: non_disponibile
        size: 6


  saldo_inziale:
    seq:
      - id: numero_progressivo
        size: 7
        type: str
        doc: numero della rendicontazione all'interno del flusso
      - id: filler1
        size: 13
      - id: codice_abi_originario_banca
        size: 5
        type: str
        doc: da valorizzare con il codice della Banca assorbita
      - id: causale
        size: 5
        type: str
        doc: assume il valore fisso 93001 o 93011
      - id: descrizione
        size: 16
        type: str
        doc: descrizione del rapporto di c/c
      - id: tipo_conto
        size: 2
        type: str
        doc: codice tipo conto assegnato dalla Banca
      - id: cin_banca
        size: 1
        type: str
        doc: carattere di controllo delle coordinate bancarie ABI
      - id: codice_abi_banca
        size: 5
        doc: codice ABI banca mittente
      - id: cab_banca
        size: 5
        type: str
        doc: cab banca mittente
      - id: conto_corrente
        size: 12
        doc: codice conto corrente BBAN
      - id: codice_divisa
        size: 3
        doc: Codice divisa
      - id: data_contabile
        size: 6
        doc: data contabile di riferimento del saldo
      - id: segno
        size: 1
        doc: assume i valori D (Debito) - C (Credito)
      - id: saldo_iniziale
        size: 15
        doc: Saldo iniziale di quadrattura della rendicontazione
      - id: codice_paese
        size: 2
        doc: Puo assumere solo i valori IT o SM
      - id: check_digit
        size: 2
        doc: Check digit IBAN
      - id: filler2
        size: 17
  
  
  movimento:
    seq:
      - id: numero_progressivo
        size: 7
        doc: stesso numero del tipo record 61 della rendicontazione
      - id: progressivo_movimento
        size: 3
        doc: inizia da 001; al raggiongimento di 999 reinizia da 001
      - id: data_valuta
        size: 6
        doc: valuta del movimento
      - id: data_registrazione
        size: 6
        doc: data di registrazione/contabile del movimento
      - id: segno_movimento
        size: 1
        doc: assume i valori D (Debito) - C (Credito)
      - id: importo_movimento
        size: 15
        doc: Importodel Movimento
      - id: causale_cbi
        size: 2
        doc: causale CBI
      - id: causale_interna
        size: 2
        doc: causale secondo la codifica proprietaria della banca
      - id: numero_assegno
        size: 16
      - id: riferimento_banca
        size: 16
        doc: numero di riferimento operazione attribuito dalla Banca
      - id: tipo_riferimento_cliente
        size: 9
        doc: NROSUPCBI o PAYORDREF o NRPRATICA o NDISTINTA o RIFESICBI
      - id: descrizione_movimento
        size: 34
        doc: NROSUPCBI o PAYORDREF o NRPRATICA o NDISTINTA o RIFESICBI
  
  
  inf_movimento:
    seq:
      - id: numero_progressivo
        size: 7
        doc: stesso numero del record 61 della rendicontazione
      - id: progressivo_movimento
        size: 3
        doc: stesso progressivo del tipo 62
      - id: flag_struttura
        size: 3
        type: str
        doc: se presente, tipo di informazione
      - id: content
        type:
          switch-on: flag_struttura
          cases:
            '"KKK"': primo_record63
            '"YYY"': primo_record63_causale_cbi48
            '"YY2"': secondo_record63
            '"ZZ1"': bonifici_estero1
            '"ZZ2"': bonifici_estero2
            '"ZZ3"': bonifici_estero3
            '"ID1"': record_id1
            '"RI1"': record_ri1
            '"RI2"': record_ri2
            _: record_gen

  
  primo_record63:
    seq:
      - id: identificativo_rapporto
        size: 23
        doc: per le operazioni di cash pooling contiene le coordinate bancarie
      - id: filler
        size: 81
  
  
  primo_record63_causale_cbi48:
    seq:
      - id: data_ordine
        size: 8
        doc: data ordine del cliente ordinante nel formato GGMMAAAA
      - id: codice_fiscale_ordinante
        size: 16
        doc: codice fiscale dell'ordinante
      - id: cliente_ordinante
        size: 40
        doc: cognome nome ovvero denominazione / ragione sociale dell'ordinante
      - id: localita
        size: 40
        doc: localita di residenza del cliente ordinante
  
  
  secondo_record63:
    seq:
      - id: indirizzo_ordinante
        size: 50
        doc: Via/piazza e numero civico di residenza del cliente ordinante
      - id: iban_ordinante
        size: 34
        doc: Coordinata IBAN completa secondo lo standard ISO 3166
      - id: filler
        size: 20
  
  
  bonifici_estero1:
    seq:
      - id: importo_originario_pagamento
        size: 18
        doc: importo disposto dall'ordinante al lordo delle commissioni
      - id: codice_divisa_importo_originario
        size: 3
        doc: codice divisa dell'importo precedente
      - id: importo_regolato
        size: 18
        doc: importo regolato tra banche
      - id: codive_divisa_regolamento
        size: 18
        doc: codice divisa dell'importo precedente
      - id: importo_negoziato
        size: 3
        doc: rapresenta il contravalore in divisa dell'importo contabilizzato
      - id: codice_divisa_importo_negoziato
        size: 3
        doc: codice divisa dell'importo precedente
      - id: cambio_applicato
        size: 12
        doc: tasso di cambio applicato
      - id: importo_commissioni
        size: 13
        doc: da indicare se non contabilizzate separamente dall'importo del pagamento
      - id: importo_spese
        size: 13
        doc: da indicare se non contabilizzate separamente dall'importo del pagamento
      - id: codice_paese
        size: 3
        doc: cod. Paese di provenienza o di destinazione dei fondi, secondo UIC
  
  
  bonifici_estero2: 
    seq:
      - id: ordinante_del_pagamento
        size: 104
        doc: indica per esteso l'ordinante del pagamento


  bonifici_estero3:
    seq:
      - id: beneficiario
        size: 50
        doc: beneficario del pagamento
      - id: motivazione_del_pagamento
        size: 54
        doc: motivazione del pagamento come indicata dalla banca
  
  
  record_id1:
    seq:
      - id: indentificativo_univoco_messaggio
        size: 35
        doc: identificativo univoco messagio
      - id: identificativo_ete
        size: 35
        doc: identificativo End to End
      - id: filler
        size: 34
  
  
  record_ri1:
    seq:
      - id: informazioni_riconcilazione
        size: 104
        doc: Informazioni di riconciliazione
  
  
  record_ri2:
    seq:
      - id: informazioni_riconcilazione
        size: 36
        doc: Informazioni di riconciliazione
      - id: filler
        size: 68


  record_gen:
    instances:
      descrizione:
        pos: 13
        size: 107
        doc: descrizione del movimento in testo libero

  
  saldo_finale:
    seq:
      - id: numero_progressivo
        size: 7
        doc: stesso numero del tipo record 61 della rendicontazione
      - id: codice_divisa
        size: 3
        doc: codice divisa
      - id: data_contabile
        size: 6
        doc: data con la quale la Banca ha contabilizzato il saldo
      - id: segno_saldo_contabile
        size: 1
        doc: assume i valori D (Debito) - C (Credito)
      - id: saldo_contabile
        size: 15
        doc: saldo contabile di chiusura della giornata di riferimento
      - id: segno_saldo_liquido
        size: 1
        doc: assume i valori D (Debito) - C (Credito)
      - id: saldo_liquido
        size: 15
        doc: saldo liquido della giornata
      - id: filler1
        size: 54
      - id: filler2
        size: 15


  liquidita_future:
    seq:
      - id: numero_progressivo
        size: 7
        doc: stesso numero del tipo record 61 della rendicontazione
      - id: saldo1
        type: saldo_liquido
      - id: saldo2
        type: saldo_liquido
      - id: saldo3
        type: saldo_liquido
      - id: saldo4
        type: saldo_liquido
      - id: saldo5
        type: saldo_liquido
      
      
  saldo_liquido:
    seq:
      - id: data_liquidita
        size: 6
        doc: data di riferimento del saldo successivo
      - id: segno
        size: 1
        doc: assume i valori D (Debito) - C (Credito)
      - id: saldo_liquido
        size: 6
        doc: saldo liquido alla data precedente
