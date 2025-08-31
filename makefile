# =========[ Makefile : Park'it P04 ]=========

# Variables
MYSQL_CONTAINER = parkit-mysql
MYSQL_ROOT_PASSWORD = rootroot
SQL_FILE = resources/Data.sql
MAIN_CLASS = com.parkit.parkingsystem.App

.PHONY: help
help: ## Affiche les commandes disponibles
	@echo "Commandes disponibles :"
	@echo "  make db-up       - Démarrer MySQL (docker-compose up -d)"
	@echo "  make db-down     - Stopper MySQL (docker-compose down)"
	@echo "  make db-seed     - Importer Data.sql dans MySQL"
	@echo "  make db-shell    - Ouvrir un shell MySQL root"
	@echo "  make compile     - Compiler les sources Java"
	@echo "  make test        - Lancer les tests Maven"
	@echo "  make package     - Builder le jar Maven"
	@echo "  make run         - Lancer App.java avec Maven (exec:java)"
	@echo "  make jar-run     - Lancer l’application via le JAR généré"
	@echo "  make clean       - Nettoyer les fichiers générés (target/)"

# ========================
# Section MySQL
# ========================

db-up: ## Démarre la base MySQL
	docker-compose up -d

db-down: ## Stoppe la base MySQL
	docker-compose down

db-seed: ## Importer Data.sql (créera prod/test)
	docker exec -i $(MYSQL_CONTAINER) mysql -uroot -p$(MYSQL_ROOT_PASSWORD) --force < $(SQL_FILE)

db-shell: ## Ouvrir un shell MySQL dans le conteneur
	docker exec -it $(MYSQL_CONTAINER) mysql -uroot -p$(MYSQL_ROOT_PASSWORD)

# ========================
# Section Maven / Java
# ========================

compile: ## Compiler le projet
	./mvnw clean compile

test: ## Lancer les tests Maven
	./mvnw clean test

package: ## Builder l'application (génère le .jar)
	./mvnw clean package

run: ## Lancer directement la classe principale avec Maven
	./mvnw exec:java -Dexec.mainClass="$(MAIN_CLASS)"

jar-run: ## Lancer l'application depuis le .jar généré
	java -jar target/parking-system-1.0-SNAPSHOT.jar

clean: ## Supprimer les fichiers générés
	./mvnw clean