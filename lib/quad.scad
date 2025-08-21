// =====================
// Hilfsfunktionen
// =====================
function mb_vadd(a,b)   = [a[0]+b[0], a[1]+b[1]];
function mb_vsub(a,b)   = [a[0]-b[0], a[1]-b[1]];
function mb_vmul(a,s)   = [a[0]*s,   a[1]*s   ];
function mb_vlen(a)     = sqrt(a[0]*a[0] + a[1]*a[1]);
function mb_vunit(a)    = let(L=mb_vlen(a)) (L==0 ? [0,0] : mb_vmul(a, 1/L));
function mb_cross2(a,b) = a[0]*b[1] - a[1]*b[0];
function mb_abs(x)      = (x<0)?-x:x;
function mb_eq(a,b,eps=1e-12) = (mb_abs(a[0]-b[0])<eps) && (mb_abs(a[1]-b[1])<eps);

// rekursive Summe der Kreuzprodukte über alle Kanten (kompatibel zu alten OpenSCADs)
function mb_cross_sum_edges(P, i=0, acc=0) =
    (i == len(P)) ? acc
                  : mb_cross_sum_edges(P, i+1, acc + mb_cross2(P[i], P[(i+1)%len(P)]));

// signierte Polygonfläche (beliebige n)
function mb_signed_area_any(P) = 0.5 * mb_cross_sum_edges(P);

// Schnittpunkt zweier Geraden: p0 + t*r  und  q0 + u*s
function mb_line_intersect(p0, r, q0, s) =
    let(den = mb_cross2(r, s))
    (abs(den) < 1e-12) ? undef
    : mb_vadd(p0, mb_vmul(r, mb_cross2(mb_vsub(q0,p0), s)/den));

// =====================
// Allgemeines n-Gon-Inset mit individueller Kantenstärke
// P: Punkte [P0..P{n-1}], d_edge[i] gehört zu Kante P[i] -> P[i+1]
// =====================
function mb_inset_ngon_edges(P, d_edge) =
    let(
        n   = len(P),
        A   = mb_signed_area_any(P),
        ccw = A > 0,

        E    = [ for (i=[0:n-1]) mb_vunit( mb_vsub(P[(i+1)%n], P[i]) ) ],
        Nccw = [ for (i=[0:n-1]) [-E[i][1], E[i][0]] ],
        N_in = [ for (i=[0:n-1]) (ccw ? Nccw[i] : mb_vmul(Nccw[i], -1)) ],
        S    = [ for (i=[0:n-1]) mb_vadd(P[i], mb_vmul(N_in[i], d_edge[i])) ]
    )
    [ for (i=[0:n-1])
        mb_line_intersect(
            S[(i-1+n)%n], E[(i-1+n)%n],
            S[i],         E[i]
        )
    ];

// =====================
// Öffentliche Funktion (dein Format) + Degeneration
// punkte:  [VorneLinks, HintenLinks, HintenRechts, VorneRechts]
// raender: [Links, Rechts, Vorne, Hinten]
// =====================
function mb_inset_quad_lrfh(punkte, raender) =
    let(
        P0 = punkte[0], P1 = punkte[1], P2 = punkte[2], P3 = punkte[3],

        // Mapping deiner Ränder -> Kanten P[i]→P[i+1]
        // 0: P0->P1 = links, 1: P1->P2 = hinten, 2: P2->P3 = rechts, 3: P3->P0 = vorne
        d_edge4 = [raender[0], raender[3], raender[1], raender[2]],

        // Degeneration (adjazente Doppelpunkte)
        is01 = mb_eq(P0,P1),
        is12 = mb_eq(P1,P2),
        is23 = mb_eq(P2,P3),
        is30 = mb_eq(P3,P0),
        no_deg = !(is01 || is12 || is23 || is30),

        // komprimierte Punktemenge + Randzuordnung für Dreieck
        Pc =  no_deg ? [P0,P1,P2,P3] :
              is01   ? [P0,P2,P3] :
              is12   ? [P0,P1,P3] :
              is23   ? [P0,P1,P2] :
                        [P3,P1,P2],

        dc =  no_deg ? d_edge4 :
              is01   ? [d_edge4[1], d_edge4[2], d_edge4[3]] :
              is12   ? [d_edge4[0], d_edge4[2], d_edge4[3]] :
              is23   ? [d_edge4[0], d_edge4[1], d_edge4[3]] :
                        [d_edge4[1], d_edge4[2], d_edge4[0]],

        // Mapping zurück auf 4 Ausgabepositionen
        map_idx = no_deg ? [0,1,2,3] :
                  is01   ? [0,0,1,2] :
                  is12   ? [0,1,1,2] :
                  is23   ? [0,1,2,2] :
                           [0,1,2,0],

        Qc = mb_inset_ngon_edges(Pc, dc),
        Q4 = [ for(i=[0:3]) Qc[ map_idx[i] ] ]
    )
    Q4;

/* // -------- Mini-Demo --------
punkte  = [[0,0],[0,80],[120,80],[120,0]];      // [VL, HL, HR, VR]
raender = [3, 6, 10, 8];                         // [links, rechts, vorne, hinten]
echo("normal =", mb_inset_quad_lrfh(punkte, raender));

punkte2 = [[0,0],[0,80],[120,80],[120,80]];     // P2==P3  -> Dreieck
echo("degeneriert =", mb_inset_quad_lrfh(punkte2, raender));
*/
