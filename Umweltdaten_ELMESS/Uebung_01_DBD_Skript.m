% Autor: Minh Tue Cung - 5081738
% Übungsaufgabe: Übung_01_DBD



x = []; 
% x ist hier ein Row-Vektor mit 720 Zeiteinträgen, für den Zeitraster
% X-Achse
hour_counter = 1;
day_counter = 1;
%Initialisiere mit "datetime" Objekt
for i = 1:720
    x = [x, datetime(2020, 9, day_counter, hour_counter, 0, 0)];
    hour_counter = hour_counter + 1;
    if hour_counter == 25
        hour_counter = 1;
        day_counter = day_counter + 1;
    end
end

% NO2 Daten (Index 3 in "DATA")
rohdaten = extrahieren_alle_720_rohdaten_einer_messgroesse('202009-LUFTHB-BH.DBD', 2, 3);
avmg = finde_den_AVMG_einer_Messgroesse('202009-LUFTHB-BH.DBD', 3);
messdaten = rohdaten_to_messdaten(rohdaten, avmg);

subplot(4,1,1);
plot(x,messdaten);
xlabel('Zeitraster');
ylabel('Messdaten NO2 (kg/m3)');

% NOX Daten (Index 4 in "DATA")
rohdaten = extrahieren_alle_720_rohdaten_einer_messgroesse('202009-LUFTHB-BH.DBD', 2, 4);
avmg = finde_den_AVMG_einer_Messgroesse('202009-LUFTHB-BH.DBD', 4);
messdaten = rohdaten_to_messdaten(rohdaten, avmg);

subplot(4,1,2);
plot(x,messdaten);
xlabel('Zeitraster');
ylabel('Messdaten NOX (kg/m3)');

% PM10 Daten (Index 6 in "DATA")
rohdaten = extrahieren_alle_720_rohdaten_einer_messgroesse('202009-LUFTHB-BH.DBD', 2, 6);
avmg = finde_den_AVMG_einer_Messgroesse('202009-LUFTHB-BH.DBD', 6);
messdaten = rohdaten_to_messdaten(rohdaten, avmg);

subplot(4,1,3);
plot(x,messdaten);
xlabel('Zeitraster');
ylabel('Messdaten PM10 (kg/m3)');

% TMP Daten (Index 10 in "DATA")
rohdaten = extrahieren_alle_720_rohdaten_einer_messgroesse('202009-LUFTHB-BH.DBD', 2, 10);
avmg = finde_den_AVMG_einer_Messgroesse('202009-LUFTHB-BH.DBD', 10);
messdaten = rohdaten_to_messdaten(rohdaten, avmg);

subplot(4,1,4);
plot(x,messdaten);
xlabel('Zeitraster');
ylabel('Messdaten TMP (°C)');



function rohdaten = extrahieren_alle_720_rohdaten_einer_messgroesse(file_name, anzahl_ZeitZahl_in_ZFMT, index_der_Messgroesse_in_DATA)
    file_id = fopen(file_name, 'rt');
    rohdaten = [1:720];
    % Erstmal den "rohdaten" Array mit 720 = 24 * 30 Einträgen
    % initialisieren
    for i = 1:length(rohdaten)
        rohdaten(i) = NaN;
    end
    % Idee: Es kann Stunden geben, wo keine Daten erfasst wurden!
    % -> Alle 720 Einträge einfach erstmal mit NaN, dann diese nach und
    % nach mit echten Rohdaten ersetzen. Keine Daten -> Bleibt NaN, damit
    % an der Stelle hier eine Lücke im Diagramm angezeigt wird
    if file_id < 0  
        error('error opening file %s\n', file_name);
    else
        % "fgets" iteriert durch jede einzelne Zeile im Text
        eine_zeile = fgets(file_id);
        eine_zeile_split = [];
        eine_zeile_split_ohne_Leerzeichen = [];
        % "fgets" gibt kein Char zurück, wenn das Ende des Textes erreicht
        % wurde -> Diese "while" zur Iteration
        while ischar(eine_zeile)
            % Split die Zeile -> einzelne Worte
            eine_zeile_split = split(eine_zeile);
            % Alle Leerzeichen entfernen
            for i = 1:length(eine_zeile_split)
                tf = strcmp(eine_zeile_split(i), '');
                if tf(1) ~= 1
                    eine_zeile_split_ohne_Leerzeichen = [eine_zeile_split_ohne_Leerzeichen, eine_zeile_split(i)];
                end
            end
            % Prüft, ob die aktuelle Zeile eine "Daten" Zeile ist
            % Signal: "Daten" Zeile enthält am Beginn eine Zahl, also
            % "digit" ("Tag"-Zahl)
            tf = isstrprop(eine_zeile_split_ohne_Leerzeichen(1), 'digit');
            % Wenn ja -> anfangen zu extrahieren!
            if tf{1} == 1 
                tag = str2num(eine_zeile_split_ohne_Leerzeichen{1});
                stunde = str2num(eine_zeile_split_ohne_Leerzeichen{2});
                % Die zu ersetzende Stelle in "rohdaten" Array hat den
                % Index 24 * (tag - 1) + stunde
                rohdaten(24 * (tag - 1) + stunde) = str2num(eine_zeile_split_ohne_Leerzeichen{anzahl_ZeitZahl_in_ZFMT + index_der_Messgroesse_in_DATA});
            end
            eine_zeile_split_ohne_Leerzeichen = [];
            eine_zeile = fgets(file_id);  
        end
    end
    fclose(file_id);
end

function avmg = finde_den_AVMG_einer_Messgroesse(file_name, index_der_Messgroesse_in_DATA)
    file_id = fopen(file_name, 'rt');
    if file_id < 0  
        error('error opening file %s\n', file_name);
    else
        eine_zeile = fgets(file_id);
        eine_zeile_split = [];
        eine_zeile_split_ohne_Leerzeichen = [];
        while ischar(eine_zeile)
            eine_zeile_split = split(eine_zeile);
            for i = 1:length(eine_zeile_split)
                tf = strcmp(eine_zeile_split(i), '');
                if tf(1) ~= 1
                    eine_zeile_split_ohne_Leerzeichen = [eine_zeile_split_ohne_Leerzeichen, eine_zeile_split(i)];
                end
            end
            tf = strcmp(eine_zeile_split_ohne_Leerzeichen(1), 'AVMG');
            if tf(1) == 1
                avmg = eine_zeile_split_ohne_Leerzeichen{1 + index_der_Messgroesse_in_DATA};
                avmg = str2num(avmg);
                break;
            end
            eine_zeile_split_ohne_Leerzeichen = [];
            eine_zeile = fgets(file_id);
        end
    end
    fclose(file_id);
end

function print_the_text_file(file_name)
    file_id = fopen(file_name, 'rt');
    if file_id < 0  
        error('error opening file %s\n', file_name);
    else
        eine_zeile = fgets(file_id);
        while ischar(eine_zeile)
            disp(eine_zeile);
            eine_zeile = fgets(file_id);
        end
    end
    fclose(file_id);
end

function anzahl = finde_Anzahl_ZeitZahl_in_ZFMT(file_name)
    % Bestimme die anzahl von ZFMT Einträgen, z.B:DD HH -> Anzahl 2
    file_id = fopen(file_name, 'rt');
    anzahl = -1;
    if file_id < 0  
        error('error opening file %s\n', file_name);
    else
        eine_zeile = fgets(file_id);
        eine_zeile_split = [];
        % Iteration, um die "ZFMT" Zeile festzustellen
        while ischar(eine_zeile)
            eine_zeile_split = split(eine_zeile);
            tf = strcmp(eine_zeile_split(1), 'ZFMT');
            % Zeile gefunden! -> den Loop abbrechen!
            if tf(1) == 1
                break
            end
            eine_zeile = fgets(file_id);
        end
        eine_zeile_split_ohne_Leerzeichen = [];
        for i = 1:length(eine_zeile_split)
            tf = strcmp(eine_zeile_split(i), '');
            % Entferne alle Leerzeichen (siehe Funktionsweise "strcmp")
            if tf(1) ~= 1
                eine_zeile_split_ohne_Leerzeichen = [eine_zeile_split_ohne_Leerzeichen, eine_zeile_split(i)];
            end
        end
        % Anzahl = length - 1 (1: das Wort "ZFMT" selbst)
        anzahl = length(eine_zeile_split_ohne_Leerzeichen) - 1;
    end
    fclose(file_id);
end

function index = finde_den_Index_einer_Messgroesse_in_dem_DATA_Eintrag(file_name, messgroesse)
    % den Index einer bestimmten Messgröße in "DATA" zu ermitteln, (den
    % "DATA" Namen selbst exklusiv), z.B: Index NO2 = 3, C0 = 1
    file_id = fopen(file_name, 'rt');
    index = -1;
    if file_id < 0  
        error('error opening file %s\n', file_name);
    else
        % Geh jede einzelne Zeile durch, um die "DATA" Zeile rauszufinden
        eine_zeile = fgets(file_id);
        eine_zeile_split = [];
        while ischar(eine_zeile)
            eine_zeile_split = split(eine_zeile);
            tf = strcmp(eine_zeile_split(1), 'DATA');
            % "DATA" Zeile gefunden -> "break" den "while" Loop
            if tf(1) == 1
                break
            end
            eine_zeile = fgets(file_id);
        end
        % Vergleichen jedes einzelne Wort mit dem Schlüsselwort
        tf = strcmp(eine_zeile_split, messgroesse);
        for i = 2:length(tf)
            if tf(i) == 1
                % Schlüsselwort gefunden, index notieren, aber index - 1
                % ("DATA" Wort exklusiv)
                index = i - 1;
                break;
            end
        end
    end
    fclose(file_id);
end

function messdaten = rohdaten_to_messdaten(rohdaten_array, avmg)
    % Alle SFKT = 0 -> Umrechnungsformel A benutzt 
    % OFFS nicht in der Datei -> standardsweise auf 0 setzen
    messdaten = [];
    for i = 1:length(rohdaten_array)
        if rohdaten_array(i) == -99
            % Hier Leerwert -> NaN, damit im Diagramm eine Lücke angezeigt
            % wird!
            messdaten(end + 1) = NaN;
        else
            % Umrechnungsformel A ohne OFFS, avmg = Ansprechvermögen
            messdaten(end + 1) = rohdaten_array(i) / avmg;
        end
    end
end

    
    
