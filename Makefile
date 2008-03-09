#executable
EXEC=freetuxtv
#compilateur
CC=@gcc -g -Wall 
#inclusion -g -Wall -ansi -pedantic -ansi -pedantic -W -Werror -Wall -Wstrict-prototypes -W -Wall -Werror -Wstrict-prototypes -Wparentheses -Wunused-function -Wunused-label -Wunused-variable -Wunused-value
CFLAGS= `pkg-config --cflags gtk+-2.0` `vlc-config --cflags vlc` -I/usr/src/vlc-trunk/include
#edition des liens
LDFLAGS= `pkg-config --libs gtk+-2.0` `vlc-config --libs vlc` -lvlc -lsqlite3
#dossiers source
SRC=./src
# .o temporaires
OBJ=./obj
# ou placer l'executable ?
BIN=.


#############################
# CONFIGURATION AUTOMATIQUE #
#############################
# l'ensemble des sources
SRCS=$(wildcard $(SRC)/*.c)
# l'ensemble des fichiers objets construits a partir des fichiers sources
OBJS=$(SRCS:$(SRC)/%.c=$(OBJ)/%.o)

#clean est une cible qui ne produit pas de fichier
.PHONY: clean

#regle pour l'edition des liens
$(BIN)/$(EXEC): $(OBJS) $(BIN) $(OBJ)
	@echo " -- Edition des liens pour l'executable: $(BIN)/$(EXEC)"
	$(CC) -o $(BIN)/$(EXEC) $(OBJS) $(LDFLAGS)

#regle pour la compilation d'un .o (lorsqu'il existe un .c et un .h correspondant)
$(OBJ)/%.o: $(SRC)/%.c $(SRC)/%.h
	@echo " -- Compilation du fichier objet: $@ (sources: $(SRC)/$*.c $(SRC)/$*.h)"
	$(CC) -c $< -o $@ $(CFLAGS)

#regle pour la compilation d'un .o (lorsqu'il n'existe qu'un .c correspondant)
$(OBJ)/%.o: $(SRC)/%.c
	@echo " -- Compilation du fichier objet: $@ (source: $(SRC)/$*.c)"
	$(CC) -c $< -o $@ $(CFLAGS)

$(OBJ):
	@echo " -- Creation du dossier: $(OBJ)"
	@mkdir $(OBJ)

$(BIN):
	@echo " -- Creation du dossier: $(BIN)"
	@mkdir $(BIN)

clean:
	@echo " -- Nettoyage"
# l'executable
	@rm -rf $(BIN)/$(EXEC)
# les .o
	@rm -rf $(OBJS)
# les fichiers de sauvegarde
	@rm -f *~$
	@rm -f $(SRC)/*~$
