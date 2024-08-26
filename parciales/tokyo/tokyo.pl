

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
1.Modelar los atletas, las disciplinas, en cuál compite cada uno, las medallas y los eventos
minimizando la repetición de lógica y respetando las consideraciones mencionadas. Dar
un par de ejemplos incluyendo disciplinas individuales y por equipos.
*/

% atleta(Nombre,Edad,Pais)

atleta(juanPerez, 28, argentina).

% disciplina(Nombre)

disciplina(voleyMasculino).
disciplina(carrera100MetrosLlanos).

% competencia(Disciplina,individual(Atleta))
% competencia(Disciplina,equipo(Pais))

competencia(voleyMasculino, equipo(argentina)).
competencia(carrera400MetrosConVallasFemenino, individual(dalilahMuhammad)).

% medalla(Material,Disicplina,individual(Atleta))
% medalla(Material,Disciplina,equipo(Pais))

medalla(bronce, voleyMasculino, equipo(argentina)).

% evento(Disciplina,Ronda,individual(Atleta))
% evento(Disciplina,Ronda,equipo(Pais))

evento(hockeyFemenino, final, equipo(argentina)).
evento(hockeyFemenino, final, equipo(paisesBajos)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
2. vinoAPasear/1: se cumple para un atleta que no compite en ninguna disciplina.
*/

vinoAPasear(Atleta):-
    atleta(Atleta,_,_),
    not(competencia(_,individual(Atleta,_,_))).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
3. medallasDelPais/3: nos dice en qué disciplinas ganaron medallas cuáles países.
Recordar que un país puede obtener medallas en disciplinas por equipo o también a
través de atletas que lo representen.
*/

medallasDelPais(Pais,Disciplina,Medalla):-
    medalla(Medalla,Disciplina,equipo(Pais)).

medallasDelPais(Pais,Disciplina,Medalla):-
    medalla(Medalla,Disciplina,individual(Atleta)),
    atleta(Atleta,_,Pais).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
4. participoEn/3: relaciona en qué rondas y disciplinas se desempeñó un atleta. Para
disciplinas individuales, dependerá de en qué eventos estuvo (puede haber participado
en las rondas 1 y 2, por ejemplo, pero no haber pasado a la ronda 3); para disciplinas en
equipo, se considera que los atletas de la disciplina participan siempre que su país
participe en la ronda. Por ejemplo, si argentina participa en octavosDeFinal de
voleyMasculino, todos los atletas argentinos que se desempeñen en voleyMasculino
participan en esa ronda.
*/

participoEn(Ronda,Disciplina,Atleta):-
    evento(Disciplina,Ronda,individual(Atleta)).

participoEn(Ronda,Disciplina,Atleta):-
    atleta(Atleta,_,Pais),
    evento(Disciplina,Ronda,equipo(Pais)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
5. dominio/2: se cumple para un país y una disciplina si todas las medallas en esa
disciplina fueron entregadas a atletas del mismo país. Naturalmente, esto sólo puede
ocurrir en disciplinas individuales.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
6. medallaRapida/1: es verdadero para las disciplinas cuyas medallas se definieron en
un evento a ronda única.
*/
medallaRapida(Disciplina):-
    medalla(_,Desciplina,_);
    evento(Disciplina,UnaRonda,_),
    not(evento(Disciplina,OtraRonda,_)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
7. noEsElFuerte/2: relaciona a un país con las disciplinas en las que no participó o sólo
participó en una ronda inicial. En los casos de disciplinas por equipos, esa ronda es
faseDeGrupos; en los casos de disciplinas individuales, es la ronda 1.
*/
noEsElFuerte(Pais,Disciplina):-
    not(participoEn(Disciplina,_,equipo(Pais))).
noEsElFuerte(Pais,Disciplina):-
    participoEn(Disciplina,faseDeGupos,equipo(Pais)),
    not(participoEn(Disciplina,OtraRonda,equipo(Pais))),
    OtraRonda\=faseDeGrupos.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
8. medallasEfectivas/2: nos dice la cuenta final de medallas de cada país. No es
simplemente la suma de medallas, sino que cada una vale distinto: las de oro suman 3,
las de plata 2, y las de bronce 1.
*/
medallasEfectivas(Pais, TotalMedallas) :-
    atleta(_,_,Pais),
    findall(Valor, valorMedallaGanada(Pais, Valor), Valores),
    sumlist(Valores, TotalMedallas).

valorMedallaGanada(Pais, Valor) :-
    medallasDelPais(Medalla, _, Pais),
    valorMedalla(Medalla, Valor).

valorMedalla(oro, 3).
valorMedalla(placa, 2).
valorMedalla(bronce, 1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
9.laEspecialidad/1: se cumple para los atletas que no vinieron a pasear y obtuvieron
medalla de oro o plata en todas las disciplinas en las que participaron.
*/
laEspecialidad(Atleta):-
    atleta(Atleta,_,_),
    not(vinoAPasear(Atleta)),
    forall(participoEn(Disciplina,_,Atleta),(medalla(Medalla,_,individual(Atleta)),Medalla \= bronce)).