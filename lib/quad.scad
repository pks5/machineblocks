// ---------- Hilfsfunktionen ----------
function mb_vadd(a,b)       = [a[0]+b[0], a[1]+b[1]];
function mb_vsub(a,b)       = [a[0]-b[0], a[1]-b[1]];
function mb_vmul(a,s)       = [a[0]*s,   a[1]*s   ];
function mb_vlen(a)         = sqrt(a[0]*a[0] + a[1]*a[1]);
function mb_vunit(a)        = let(L=mb_vlen(a)) (L==0 ? [0,0] : mb_vmul(a, 1/L));
function mb_cross2(a,b)     = a[0]*b[1] - a[1]*b[0];     // z-Komponente (2D)
function mb_signed_area(P)  = 0.5*(
    mb_cross2(P[0],P[1]) + mb_cross2(P[1],P[2]) + mb_cross2(P[2],P[3]) + mb_cross2(P[3],P[0])
);

// Schnittpunkt zweier Geraden: p0 + t*r  und  q0 + u*s
function mb_line_intersect(p0, r, q0, s) =
    let(den = mb_cross2(r, s))
    (abs(den) < 1e-12) ? undef
    : mb_vadd(p0, mb_vmul(r, mb_cross2(mb_vsub(q0,p0), s)/den));

// ---------- Kern: Offset je Kante (d_edge[i] gehört zu Kante P[i] -> P[i+1]) ----------
function mb_inset_quad_edges(P, d_edge) =
    let(
        A     = mb_signed_area(P),
        ccw   = A > 0,
        E     = [ for (i=[0:3]) mb_vunit( mb_vsub(P[(i+1)%4], P[i]) ) ],
        Nccw  = [ for (i=[0:3]) [-E[i][1], E[i][0]] ],
        N_in  = [ for (i=[0:3]) (ccw ? Nccw[i] : mb_vmul(Nccw[i], -1)) ],
        S     = [ for (i=[0:3]) mb_vadd(P[i], mb_vmul(N_in[i], d_edge[i])) ]
    )
    [ for (i=[0:3])
        mb_line_intersect(
            S[(i+3)%4], E[(i+3)%4],
            S[i],       E[i]
        )
    ];

// ---------- Öffentliche Funktion mit deinem Format ----------
// punkte: [VorneLinks, HintenLinks, HintenRechts, VorneRechts]
// raender: [Links, Rechts, Vorne, Hinten]
function mb_inset_quad_lrfh(punkte, raender) =
    let(
        // Kanten-Indizes (entsprechend punkte):
        // 0: P0->P1 = Linke Seite
        // 1: P1->P2 = Hinten
        // 2: P2->P3 = Rechte Seite
        // 3: P3->P0 = Vorne
        d_edge = [
            raender[0],  // links  -> Kante 0
            raender[3],  // hinten -> Kante 1
            raender[1],  // rechts -> Kante 2
            raender[2]   // vorne  -> Kante 3
        ]
    )
    mb_inset_quad_edges(punkte, d_edge);

