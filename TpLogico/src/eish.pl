% Punto 1:
/*
1.  Modelar lo necesario para representar los jugadores, las civilizaciones y las tecnologías, de la forma más conveniente
para resolver los siguientes puntos. Incluir los siguientes ejemplos.
        a.  Ana, que juega con los romanos y ya desarrolló las tecnologías de herrería, forja, fundición y láminas.
        b.  Beto, que juega con los incas y ya desarrolló herrería, forja y fundición.
        c.  Carola, que juega con los romanos y sólo desarrolló la herrería.
        d.  Dimitri, que juega con los romanos y ya desarrolló herrería y emplumado.
        e.  Elsa no juega esta partida.
*/

juegaCon(ana, romanos).
juegaCon(beto, incas).
juegaCon(carola, romanos).
juegaCon(dimitri, romanos).

desarrollo(ana, herreria).
desarrollo(ana, forja).
desarrollo(ana, fundicion).
desarrollo(ana, laminas).

desarrollo(beto, herreria).
desarrollo(beto, forja).
desarrollo(beto, fundicion).

desarrollo(carola, herreria).

desarrollo(dimitri, herreria).
desarrollo(dimitri, emplumado).

jugador(Player):- juegaCon(Player, _).
tecnologia(herreria).
tecnologia(emplumado).
tecnologia(fundicion).
tecnologia(forja).

% Punto 2:
/*
Saber si un jugador es experto en metales, que sucede cuando desarrolló las tecnologías de herrería, forja y o bien
desarrolló fundición o bien juega con los romanos.
En los ejemplos, Ana y Beto son expertos en metales, pero Carola y Dimitri no.

*/
expertoEnMetales(Nombre) :-
        desarrollo(Nombre, herreria),
        desarrollo(Nombre, forja),
        fundidorORomano(Nombre).

fundidorORomano(Nombre) :-
        desarrollo(Nombre, fundicion).

fundidorORomano(Nombre) :-
        juegaCon(Nombre, romanos).

% Punto 3: Saber si una civilización es popular
/*
Saber si una civilización es popular, que se cumple cuando la eligen varios jugadores (más de uno).
En los ejemplos, los romanos son una civilización popular, pero los incas no.
*/
civilizacionPopular(Civilizacion) :-
        juegaCon(UnJugador, Civilizacion),
        juegaCon(OtroJugador, Civilizacion),
        UnJugador \= OtroJugador.


% Punto 4:
/*
    Saber si una tecnología tiene alcance global, que sucede cuando a nadie le falta desarrollarla.
    En los ejemplos, la herrería tiene alcance global, pues Ana, Beto, Carola y Dimitri la desarrollaron.
*/   
laTecnologiaEsGlobal(Tecnologia):-
        tecnologia(Tecnologia),
        forall(jugador(Jugador), desarrollo(Jugador, Tecnologia)).

% Punto 5:
/*
    Saber cuándo una civilización es líder. Se cumple cuando esa civilización alcanzó todas las tecnologías que alcanzaron
    las demás. Una civilización alcanzó una tecnología cuando algún jugador de esa civilización la desarrolló.
    En los ejemplos, los romanos son una civilización líder pues entre Ana y Dimitri, que juegan con romanos, ya tienen
    todas las tecnologías que se alcanzaron.
*/

civilizacionLider(CivilizacionLider) :-
        juegaCon(_, CivilizacionLider),
        forall(desarrollo(_, Tecnologia), alcanzoLaTecnologia(CivilizacionLider, Tecnologia)).

alcanzoLaTecnologia(Civilizacion, Tecnologia) :-
        juegaCon(Jugador, Civilizacion),
        desarrollo(Jugador, Tecnologia).
        

%%%%%%%%%%%%%%%%%%%%% PARTE 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Punto 1

jugador2(Jugador):-
        tieneUnidad(Jugador, _).

% tieneUnidad(Jugador, Unidad()).
tieneUnidad(ana, jinete(caballo)).
tieneUnidad(ana, piquero(1, escudo)).
tieneUnidad(ana, piquero(2, sinEscudo)).

tieneUnidad(beto, campeon(100)).
tieneUnidad(beto, campeon(80)).
tieneUnidad(beto, piquero(1, escudo)).
tieneUnidad(beto, jinete(camello)).

tieneUnidad(carola, piquero(3, sinEscudo)).
tieneUnidad(carola, piquero(2, escudo)).

%%% Punto 2
unidadConMasVida(Jugador, UnidadMasViva) :-
        tieneUnidad(Jugador, UnidadMasViva),
        vidaDeUnidad(UnidadMasViva, VidaMasGrande),
        forall(tieneUnidad(Jugador, Unidad), (vidaDeUnidad(Unidad, Vida), Vida =< VidaMasGrande)). % NUNCA AGREGAR LA CONDICION "UnidadMasViva \= Unidad". Lo rompe.
        
% vidaDeUnidad(Unidad, Vida).
vidaDeUnidad(jinete(camello), 80).
vidaDeUnidad(jinete(caballo), 90).
vidaDeUnidad(campeon(Vida), Vida).
vidaDeUnidad(piquero(1, sinEscudo), 50).
vidaDeUnidad(piquero(2, sinEscudo), 65).
vidaDeUnidad(piquero(3, sinEscudo), 70).
% opcion 1
vidaDeUnidad(piquero(Nivel, escudo), Vida) :-
        vidaDeUnidad(piquero(Nivel, sinEscudo), VidaBase),
        Vida is VidaBase * 1.1.

% opcion 2
/* Esta opcion es fea, pero capaz me llegan a decir que como es más fácil de leer es mejor. Aunque sea hardcodeada y repetitiva.
vidaDeUnidad(piquero(1, escudo), 55). 
vidaDeUnidad(piquero(2, escudo), 71.5).
vidaDeUnidad(piquero(3, escudo), 77).
*/


%%%% Punto 3

/*
Queremos saber si una unidad le gana a otra. Las unidades tienen una ventaja por tipo sobre otras.
Cualquier jinete le gana a cualquier campeón, cualquier campeón le gana a cualquier piquero y cualquier
piquero le gana a cualquier jinete, pero los jinetes a camello le ganan a los a caballo. En caso de que
no exista ventaja entre las unidades, se compara la vida (el de mayor vida gana). 

Este punto no necesita ser inversible.
Por ejemplo, un campeón con 95 de vida le gana a otro con 50, pero un campeón con 100 de vida no le
gana a un jinete a caballo.
*/

% leGana(Ganador, Perdedor)
leGana(Unidad, OtraUnidad):-
        tieneVentaja(Unidad, OtraUnidad).

leGana(Unidad, OtraUnidad):-
        not(tieneVentaja(OtraUnidad, Unidad)),
        tieneMasVida(Unidad, OtraUnidad).

tieneVentaja(jinete(_), campeon(_)).
tieneVentaja(campeon(_), piquero(_, _)).
tieneVentaja(piquero(_, _), jinete(_)).
tieneVentaja(jinete(camello), jinete(caballo)).

tieneMasVida(UnaUnidad, OtraUnidad) :-
        vidaDeUnidad(UnaUnidad, UnaVida),
        vidaDeUnidad(OtraUnidad, OtraVida),
        UnaVida > OtraVida.

sonDelMismoTipo(campeon(_), campeon(_)).
sonDelMismoTipo(piquero(_, _), piquero(_, _)).
sonDelMismoTipo(jinete(Animal), jinete(Animal)). % Estos empatan sí o sí, quizás es innecesario.

% #########
% ### 4 ###
% #########

/*
Saber si un jugador puede sobrevivir a un asedio. Esto ocurre si tiene más piqueros con escudo que sin escudo.
En los ejemplos, Beto es el único que puede sobrevivir a un asedio, pues tiene 1 piquero con escudo y 0 sin escudo.
*/

puedeSobrevivirAsedio(Jugador) :-
        tieneUnidad(Jugador, _),
        cantidadUnidades(Jugador, piquero(_, escudo), CantidadEscudo),
        cantidadUnidades(Jugador, piquero(_, sinEscudo), CantidadSinEscudo),
        CantidadEscudo > CantidadSinEscudo.


cantidadUnidades(Jugador, Unidad, Cantidad) :-
        findall(Unidad, tieneUnidad(Jugador, Unidad), Unidades),
        length(Unidades , Cantidad).    


% #########
% ### 5 ###
% #########

% 5 A)
dependeDe(horno,fundicion).
dependeDe(fundicion, forja).
dependeDe(forja, herreria).

dependeDe(punzon, emplumado).
dependeDe(emplumado, herreria).

dependeDe(placas, malla).
dependeDe(malla, laminas).
dependeDe(laminas, herreria).

dependeDe(arado, collera).
dependeDe(collera, molino).


% B)

dependencia(Tecnologia) :- 
        dependeDe(Tecnologia, _).

dependencia(Tecnologia) :- 
        dependeDe(_, Tecnologia).

puedeDesarrollar(Jugador, Tecnologia) :-
        juegaCon(Jugador, _),
        dependencia(Tecnologia),
        not(desarrollo(Jugador, Tecnologia)),
        puedeDesarrollarBis(Jugador, Tecnologia).

puedeDesarrollarBis(Jugador, Tecnologia):-
        desarrollo(Jugador, Base),
        dependeDe(Tecnologia, Base).
puedeDesarrollarBis(Jugador, Tecnologia):-
        not(dependeDe(Tecnologia, _)).
        % forall(dependeDirectaOIndirectamente(Tecnologia, Dependencia), desarrollo(Jugador, Dependencia)).

% predicado recursivo 8)-|-<
dependeDirectaOIndirectamente(Tecnologia, Dependencia) :- % Caso directo
        dependeDe(Tecnologia, Dependencia).

% dependeDirectaOIndirectamente(Tecnologia, Dependencia) :-
%         dependeDe(Tecnologia, TerceraTecnologia),
%         dependeDirectaOIndirectamente(TerceraTecnologia, Dependencia).
