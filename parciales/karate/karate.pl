%alumnoDe(Maestro, Alumno)
alumnoDe(miyagui, sara).
alumnoDe(miyagui, bobby).
alumnoDe(miyagui, sofia).
alumnoDe(chunLi, guidan).

% destreza(alumno, velocidad, [habilidades]).
destreza(sofia, 80, [golpeRecto(40, 3),codazo(20)]).
destreza(sara, 70, [patadaRecta(80, 2), patadaDeGiro(90, 95, 2), golpeRecto(1, 90)]).
destreza(bobby, 80, [patadaVoladora(100, 3, 2, 90), patadaDeGiro(50, 20, 1)]).
destreza(guidan, 70, [patadaRecta(60, 1), patadaVoladora(100, 3, 2, 90), patadaDeGiro( 70, 80 1)]).

% Además se conocen los cinturones que fueron obteniendo cada uno de los alumnos (están en el orden en que los ganaron)
% categoria(Alumno, Cinturones)
categoria(sofia, [blanco]).
categoria(sara, [blanco, amarillo, naranja, rojo, verde, azul, violeta, marron, negro]).
categoria(bobby, [blanco, amarillo, naranja, rojo, verde, azul,violeta, marron, negro]).
categoria(guidan, [blanco, amarillo, naranja]).

% --------------------------------------------------------------------------
% 1) esBueno/1, Se verifica si el alumno sabe hacer al menos dos patadas distintas o puede realizar un golpe recto a una velocidad media (entre 50 y 80, inclusive los límites).
esBueno(Alumno):-
    destreza(Alumno,Vel,Habilidades),
    member(golpeRecto(_,_),Habilidades),
    Vel >= 50,
    Vel =< 80.

esBueno(Alumno):-
    destreza(Alumno,_,Habilidades),
    poseeAlmenosDosPatadas(Habilidades).

poseeAlmenosDosPatadas(Habilidades):-
    member(UnaPatada,Habilidades),
    member(OtraPatada,Habilidades),
    esPatada(UnaPatada),
    esPatada(OtraPatada),
    UnaPatada \= OtraPatada.

    esPatada(patadaDeGiro(_,_,_)).
    esPatada(patadaRecta(_,_)).
    esPatada(patadaVoladora(_,_,_,_)).

% --------------------------------------------------------------------------
% 2) esAptoParaTorneo/1, se verifica si el alumno es bueno y además haya alcanzado el cinturón verde (puede que lo haya superado).
esAptoParaTorneo(Alumno):-
    esBueno(Alumno),
    alcanzoCinturon(Alumno,verde).

alcanzoCinturon(Alumno,Cinturon):-
    categoria(Alumno,Cinturones),
    member(Cinturon,Cinturones).

% --------------------------------------------------------------------------
% 3) totalPotencia/2, relaciona un alumno con la potencia total de todas sus habilidades. La potencia total se calcula como la suma de las potencias de todas sus habilidades.
totalPotencia(Alumno,PotenciaTotal):-
    destreza(Alumno,_,Habilidades),
    findall(Potencia,(member(Habilidad,Habilidades),potenciaHabilidad(Habilidad,Potencia)), Potencias),
    sumlist(Potencias, PotenciaTotal).
    
    potenciaHabilidad(patadaDeGiro(Potencia,_,_),Potencia).
    potenciaHabilidad(patadaRecta(Potencia,_),Potencia).
    potenciaHabilidad(patadaVoladora(Potencia,_,_,_),Potencia).
    potenciaHabilidad(codazo(Potencia),Potencia).
    potenciaHabilidad(golpeRecto(_,Potencia),Potencia).

% --------------------------------------------------------------------------
% 4) alumnoConMayorPotencia/1, conocer el alumno que sea máximo según su cantidad de potencia.
alumnoConMayorPotencia(Alumno):-
    totalPotencia(Alumno,PotenciaMaxima),
    forall(totalPotencia(OtroAlumno,PotenciaOtroAlumno),PotenciaMaxima < PotenciaOtroAlumno),
    Alumno \= OtroAlumno.

% --------------------------------------------------------------------------
% 5) sinPatadas/1, permite conocer si un alumno no sabe realizar patadas.
sinPatadas(Alumno):-
    destreza(Alumno,_,Habilidades),
    not(poseePatada(Habilidades)).

poseePatada(Habilidades):-
    member(Patada,Habilidades),
    esPatada(Patada).

% --------------------------------------------------------------------------
% 6) soloSabePatear/1, se verifica si un alumno sólo sabe únicamente realizar patadas.
soloSabePatear(Alumno):-
    destreza(Alumno,_,Habilidades),
    forall(member(Habilidad,Habilidades),esPatada(Habilidad)).

% --------------------------------------------------------------------------
/* === TORNEOS ===
7) potencialesSemifinalistas/1 , conocer el conjunto de los posibles alumnos semifinalistas. Para llegar a la semifinal debe cumplir alguna de las condiciones:
● Ser aptos para el torneo;
● Provenir de un maestro que tenga más de un alumno.
● Deben poder realizar alguna habilidad con buen estilo artístico, es decir con una potencia de 100 o una puntería de 90.
*/

potencialesSemifinalistas(Alumno):-
    esAptoParaTorneo(Alumno),
    alumnoDe(Maestro,Alumno),
    poseeMasDeDosAlumnos(Maestro),
    poseeHabilidadArtistica(Alumno).

poseeMasDeDosAlumnos(Maestro):-
    alumnoDe(Maestro,UnAlumno),
    alumnoDe(Maestro,OtroAlumno),
    UnAlumno \= OtroAlumno.

poseeHabilidadArtistica(Alumno):-
    destreza(Alumno,_,Habilidades),
    member(Habilidad,Habilidades),
    habilidadArtistica(Habilidad).

habilidadArtistica(golpeRecto(_,100)).
habilidadArtistica(codazo(100)).
habilidadArtistica(patadaDeGiro(100,_,_)).
habilidadArtistica(patadaVoladora(100,_,_,_)).
habilidadArtistica(patadaRecta(100,_)).
habilidadArtistica(patadaDeGiro(_,90,_)).
habilidadArtistica(patadaVoladora(_,_,_,90)).

% --------------------------------------------------------------------------
% 8) semifinalistas/1, conocer todos los posibles conjuntos de alumnos que llegan a la semifinal. Tener en cuenta que en la semifinal llegan sólo 4 alumnos.
semiFinalistas(Alumno):-
    alumnoDe(_,Alumno),
    findall(Alumno,potencialesSemifinalistas(Alumno),SemiFinalistas),
    length(SemiFinalistas,4).
    
% --------------------------------------------------------------------------
% 9) Justificar donde se aprovecharon los conceptos de polimorfismo y orden superior. Y qué beneficios tiene su uso en la solución.
