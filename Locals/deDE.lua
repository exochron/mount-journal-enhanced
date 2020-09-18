﻿local ADDON_NAME, ADDON = ...

if (GetLocale() ~= "deDE") then
    return
end

ADDON.isMetric = true -- is the metric or imperial/us unit system used?
local L = ADDON.L or {}

L["Black Market"] = "Schwarzmarkt"
L["Family"] = "Familie"
L["FAVOR_DISPLAYED"] = "Alle Angezeigten Wählen"
L["FAVOR_PER_CHARACTER"] = "Pro Charakter"
L["Flying"] = "Luft"
L["Ground"] = "Boden"
L["Hidden"] = "Ausgeblendete"
L["Only tradable"] = "Nur handelbare"
L["Only usable"] = "Nur benutzbare"
L["Passenger"] = "Passagier"
L["Reset filters"] = "Filter zurücksetzen"
L["Show in Collections"] = "In Sammlung anzeigen"
L["SORT_FAVORITES_FIRST"] = "Favoriten zuerst"
L["SORT_REVERSE"] = "Sortierung umkehren"
L["SORT_UNOWNED_BOTTOM"] = "Nicht gesammelt nach unten"
L["TASK_END"] = "[MJE] Uff! Endlich geschafft."
L["TASK_FAVOR_START"] = "[MJE] Bitte warten. Deine Reittiere werden mit Sternen neu beklebt."
L["Transform"] = "Verwandlung"
L["Underwater"] = "Unterwasser"

-- Families
L["Airplanes"] = "Flugzeuge"
L["Airships"] = "Luftschiffe"
L["Alpacas"] = "Alpakas"
L["Amphibian"] = "Amphibien"
L["Aqir Flyers"] = "Aqir-Flieger"
L["Arachnids"] = "Spinnentiere"
L["Assault Wagons"] = "Angriffswagen"
L["Basilisks"] = "Basilisken"
L["Bats"] = "Fledermäuse"
L["Bears"] = "Bären"
L["Bees"] = "Bienen"
L["Birds"] = "Vögel"
L["Blood Ticks"] = "Blutschwärmer"
L["Boars"] = "Eber"
L["Bovids"] = "Hornträger"
L["Brutosaurs"] = "Brutosaurier"
L["Camels"] = "Kamele"
L["Carnivorans"] = "Raubtiere"
L["Carpets"] = "Teppiche"
L["Cats"] = "Katzen"
L["Chargers"] = "Streitrosse"
L["Chickens"] = "Hühner"
L["Clefthooves"] = "Spalthufe"
L["Cloud Serpents"] = "Wolkenschlangen"
L["Core Hounds"] = "Kernhunde"
L["Crabs"] = "Krabben"
L["Cranes"] = "Kraniche"
L["Crawgs"] = "Kroggs"
L["Crocolisks"] = "Krokilisk"
L["Crows"] = "Krähen"
L["Demonic Hounds"] = "Dämonische Hunde"
L["Demonic Steeds"] = "Dämonische Pferde"
L["Demons"] = "Dämonen"
L["Dinosaurs"] = "Dinosaurier"
L["Dire Wolves"] = "Terrorwölfe"
L["Direhorns"] = "Terrorhörner"
L["Discs"] = "Flugscheiben"
L["Dragonhawks"] = "Drachenfalken"
L["Drakes"] = "Drachen"
L["Dread Ravens"] = "Schreckensraben"
L["Elekks"] = "Elekks"
L["Elementals"] = "Elementare"
L["Falcosaurs"] = "Falkosaurier"
L["Fathom Rays"] = "Tiefenrochen"
L["Feathermanes"] = "Federmähnen"
L["Felsabers"] = "Teufelssäbler"
L["Fish"] = "Fische"
L["Flying Steeds"] = "Fliegende Pferde"
L["Foxes"] = "Füchse"
L["Goats"] = "Ziegen"
L["Grand Drakes"] = "Großdrachen"
L["Gronnlings"] = "Gronnlinge"
L["Gryphons"] = "Greifen"
L["Gyrocopters"] = "Gyrokopter"
L["Hawkstriders"] = "Falkenschreiter"
L["Hippogryphs"] = "Hippogryphen"
L["Horned Steeds"] = "Behornte Pferde"
L["Horses"] = "Pferde"
L["Hounds"] = "Hunde"
L["Hovercraft"] = "Luftkissenfahrzeug"
L["Humanoids"] = "Humanoide"
L["Hyenas"] = "Hyänen"
L["Infernals"] = "Höllenbestien"
L["Insects"] = "Insekten"
L["Jellyfish"] = "Quallen"
L["Jet Aerial Units"] = "Lufteinheiten"
L["Kites"] = "Flugdrachen"
L["Kodos"] = "Kodos"
L["Krolusks"] = "Krolusk"
L["Lions"] = "Löwen"
L["Mammoths"] = "Mammuts"
L["Mana Rays"] = "Manarochen"
L["Manasabers"] = "Manasäbler"
L["Mechanical Animals"] = "Mechanische Tiere"
L["Mechanical Birds"] = "Mechanische Vögel"
L["Mechanical Cats"] = "Mechanische Katzen"
L["Mechanical Steeds"] = "Mechanische Pferde"
L["Mechanostriders"] = "Roboschreiter"
L["Mecha-suits"] = "Mecha"
L["Moose"] = "Elche"
L["Motorcycles"] = "Motorräder"
L["Mountain Horses"] = "Bergpferde"
L["Mushan"] = "Mushans"
L["Nether Drakes"] = "Netherdrachen"
L["Nether Rays"] = "Netherrochen"
L["N'Zoth Serpents"] = "N'Zoth-Schlangen"
L["Others"] = "Andere"
L["Pandaren Phoenixes"] = "Pandarenphönixe"
L["Parrots"] = "Papageien"
L["Phoenixes"] = "Phönixe"
L["Proto-Drakes"] = "Protodrachen"
L["Pterrordaxes"] = "Pterrordaxe"
L["Quilen"] = "Qilen"
L["Rams"] = "Widder"
L["Raptors"] = "Raptoren"
L["Rats"] = "Ratten"
L["Ravagers"] = "Felshetzer"
L["Rays"] = "Rochen"
L["Reptiles"] = "Reptilien"
L["Rhinos"] = "Rhinozerosse"
L["Riverbeasts"] = "Flussbestien"
L["Rockets"] = "Raketen"
L["Ruinstriders"] = "Ruinprescher"
L["Rylaks"] = "Rylaks"
L["Sabers"] = "Säbler"
L["Scorpions"] = "Skorpione"
L["Sea Serpents"] = "Seeschlangen"
L["Seahorses"] = "Seepferde"
L["Silithids"] = "Qirajipanzerdrohnen"
L["Snapdragons"] = "Schnappdrachen"
L["Spider Tanks"] = "Mechaspinnen"
L["Spiders"] = "Spinnen"
L["Steeds"] = "Pferde"
L["Stingrays"] = "Stachelrochen"
L["Stone Cats"] = "Steinkatzen"
L["Stone Drakes"] = "Steindrachen"
L["Talbuks"] = "Talbuks"
L["Tallstriders"] = "Schreiter"
L["Talonbirds"] = "Raben"
L["Tigers"] = "Tiger"
L["Toads"] = "Kröten"
L["Turtles"] = "Schildkröten"
L["Undead Drakes"] = "Untote Drachen"
L["Undead Steeds"] = "Untote Pferde"
L["Undead Wolves"] = "Untote Wölfe"
L["Ungulates"] = "Huftiere"
L["Ur'zul"] = "Ur'zul"
L["Vehicles"] = "Fahrzeuge"
L["Vultures"] = "Geier"
L["War Wolves"] = "Kriegswölfe"
L["Water Striders"] = "Wasserschreiter"
L["Wind Drakes"] = "Winddrachen"
L["Wolfhawks"] = "Wolfsfalken"
L["Wolves"] = "Wölfe"
L["Wyverns"] = "Wyvern"
L["Yaks"] = "Yaks"
L["Yetis"] = "Yetis"

-- Settings
L["SETTING_ACHIEVEMENT_POINTS"] = "Zeige Erfolgspunkte"
L["SETTING_COMPACT_LIST"] = "Kompakte Mount-Liste"
L["SETTING_CURSOR_KEYS"] = "Aktiviere Aufwärts- und Abwärtspfeiltaste zum Durchblättern"
L["SETTING_FAVORITE_PER_CHAR"] = "Speichere Favoriten pro Charakter"
L["SETTING_HEAD_BEHAVIOUR"] = "Verhalten"
L["SETTING_MOUNT_COUNT"] = "Zeige Reittieranzahl diesen Charakters"
L["SETTING_MOVE_EQUIPMENT"] = "Verschiebe Ausrüstungsplatz in Modellanzeige"
L["SETTING_PERSONAL_FILTER"] = "Wende Filter-Einstellungen nur bei diesem Charakter an"
L["SETTING_PERSONAL_HIDDEN_MOUNTS"] = "Benutze versteckte Reittiere nur bei diesem Charakter"
L["SETTING_PERSONAL_UI"] = "Benutze Interface-Einstellungen nur bei diesem Charakter"
L["SETTING_PREVIEW_LINK"] = "Zeige Knopf zur Sammlung in Anprobe"
L["SETTING_SHOP_BUTTON"] = "Zeige Shop bei verfügbaren Reittieren"
L["SETTING_SHOW_USAGE"] = "Zeige Statistiken zum Nutzungsverhalten"
L["SETTING_TRACK_USAGE"] = "Verfolge Reittier Nutzungsverhalten bei allen Charakteren "
L["SETTING_YCAMERA"] = "Aktiviere Y-Rotation via Maus in Modellanzeige"
