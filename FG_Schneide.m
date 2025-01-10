% Verzeichnis auswählen
folder = uigetdir; % Pfad zum Verzeichnis mit .txt-Dateien

% Dateien im Verzeichnis finden
files = dir(fullfile(folder, '*.txt'));

% Struktur für die Ergebnisse initialisieren
results = struct();

% Durchlaufe alle Dateien
for i = 1:numel(files)
    filename = files(i).name;
    filepath = fullfile(files(i).folder, filename);
    
    % Dateiname parsen, um Versuch_Schneide und Ring zu bestimmen
    parts = strsplit(filename, '_');
    if numel(parts) < 3
        continue; % Ignoriere Dateien, die das Muster nicht erfüllen
    end
    versuch_schneide = matlab.lang.makeValidName(parts{1}); % Gültiger Name für Struktur
    ring = matlab.lang.makeValidName(parts{2}); % Gültiger Name für Struktur
    suffix = parts{3};
    
    % Nur 001, 002 und 003 berücksichtigen
    if ~ismember(suffix, {'001.txt', '002.txt', '003.txt'})
        continue;
    end
    
    % Daten einlesen und verarbeiten
    data = load_txt_data(filepath);
    
    % Berechnung der Erhebung im Hügelbereich
    erhebung = berechne_erhebung(data);
    
    % Mittlere Erhebung und Standardabweichung sammeln
    if ~isfield(results, versuch_schneide)
        results.(versuch_schneide) = struct(); % Initialisiere das Feld für Versuch_Schneide
    end
    if ~isfield(results.(versuch_schneide), ring)
        results.(versuch_schneide).(ring) = []; % Initialisiere das Feld für Ring, falls es noch nicht existiert
    end
    results.(versuch_schneide).(ring) = [results.(versuch_schneide).(ring); erhebung];
end

% Struktur in eine Tabelle umwandeln
T = table;
row = 1;
for versuch_schneide = fieldnames(results)'
    for ring = fieldnames(results.(versuch_schneide{1}))'
        values = results.(versuch_schneide{1}).(ring{1});
        T(row, :) = {versuch_schneide{1}, ring{1}, mean(values), std(values)};
        row = row + 1;
    end
end
T.Properties.VariableNames = {'Versuch_Schneide', 'Ring', 'Mittelwert', 'Standardabweichung'};

% Tabelle nach der ersten Spalte 'Versuch_Schneide' alphabetisch sortieren
T = sortrows(T, 'Versuch_Schneide');

% Tabelle in den Workspace speichern
assignin('base', 'ErgebnisTabelle', T);
disp('Tabelle "ErgebnisTabelle" wurde in den Workspace gespeichert.');

% Erstelle einzelne Plots für jeden Versuch_Schneide
unique_versuche = unique(T.Versuch_Schneide);
for i = 1:numel(unique_versuche)
    current_versuch = unique_versuche{i};
    
    % Filter für den aktuellen Versuch_Schneide
    data_for_plot = T(strcmp(T.Versuch_Schneide, current_versuch), :);
    
    % Konvertiere Ring-Werte in numerische Werte für die Sortierung und Achsenbeschriftung
    ring_numbers = cellfun(@(x) str2double(regexp(x, '\d+', 'match', 'once')), data_for_plot.Ring);
    [~, sort_idx] = sort(ring_numbers); % Sortieren nach Ringnummer
    
    % Daten sortieren für den Plot
    sorted_ring_numbers = ring_numbers(sort_idx);
    sorted_mittelwerte = data_for_plot.Mittelwert(sort_idx);
    
    % Plot erstellen
    figure('Name', ['Plot für ' current_versuch], 'NumberTitle', 'off');
    plot(sorted_ring_numbers, sorted_mittelwerte, '-o');
    xlabel('Ringnummer');
    ylabel('Mittelwert');
    title(['Mittelwerte für ' current_versuch]);
    grid on;
end

% Hilfsfunktion zum Einlesen der Datei
function data = load_txt_data(filepath)
    % Öffnet die Datei und liest nur die relevanten Daten ein (X und Z-Koordinaten)
    fileID = fopen(filepath, 'r');
    rawData = textscan(fileID, '%s', 'Delimiter', '\n');
    fclose(fileID);
    
    % Finde das Ende des Headers
    header_end = find(contains(rawData{1}, '[PROFILE_VALUES]'), 1);
    daten = rawData{1}(header_end + 1:end);
    
    % Koordinaten extrahieren (nur X und Z)
    coordData = [];
    for i = 1:numel(daten)
        line = daten{i};
        if contains(line, '=')
            parts = strsplit(line, '=');
            values = sscanf(parts{2}, '%f %f %f'); % X, Y, Z
            if numel(values) >= 3
                coordData = [coordData; values(1), values(3)]; % Nur X und Z speichern
            end
        end
    end
    data = coordData;
end

% Hilfsfunktion zur Berechnung der Erhebung im Hügelbereich
function erhebung = berechne_erhebung(data)
    z_values = data(:, 2); % Z-Koordinate
    min_slope = 0.001; % Mindestwert für signifikanten Anstieg
    window_size = 5; % Fenstergröße zur Glättung des Anstiegs
    start_idx = 1;
    end_idx = length(z_values);

    % Suche nach dem Beginn des signifikanten Anstiegs
    for i = window_size+1:length(z_values)
        if mean(diff(z_values(i-window_size:i))) > min_slope
            start_idx = max(1, i - 10); % Setze Startpunkt mit Puffer
            break;
        end
    end

    % Suche nach dem Ende des signifikanten Anstiegs
    for i = start_idx+window_size:length(z_values)-window_size
        if mean(diff(z_values(i:i+window_size))) < -min_slope
            end_idx = min(length(z_values), i + window_size + 5); % Setze Endpunkt mit Puffer
            break;
        end
    end

    % Bereich des Hügel mit Puffer
    hill_data = z_values(start_idx:end_idx);
    erhebung = max(hill_data) - min(hill_data);
end