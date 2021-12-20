//
//  UIntxUtils.c
//  icried
//
//  Created by Nikita Kiselov on 12/19/21.
//

#include "UIntxUtils.h"

static inline void mvc(uint64_t* d, int di, int db, const uint64_t* s, int si, int sb, int n);

void mv(uint64_t* d, int di, const uint64_t* s, int si, int n){
    int r = di-si;
    int sh = r/64;
    int c = r%64;
    if(c<0){
        c+=64;
        sh-=1;
    }
    int cr = 64-c;
    int big = (si+n)/64;
    int i = si/64;
    int st = si&63;
    int en = 64;
    while(i<=big){
        if(i==big){
            en = (si+n)&63;
        }
        if(en>cr && st>cr){
            //printf("0\n");
            mvc(d, i+sh+1, st-cr, s, i, st, en-st);
        }else if(en<cr && st<cr){
            //printf("1\n");
            mvc(d, i+sh, c+st, s, i, st, en-st);
        }else{
            //printf("2\n");
            mvc(d, i+sh, c+st, s, i, st, cr-st);
            mvc(d, i+sh+1, 0, s, i, cr, en-cr);
        }
        st = 0;
        i++;
    }
}

static inline void mvc(uint64_t* d, int di, int db, const uint64_t* s, int si, int sb, int n){
    //printf("%i, %i -> %i, %i : %i\n",si,sb,di,db,n);
    uint64_t mask = n==64 ? 0xFFFFFFFFFFFFFFFF : (((uint64_t)1)<<n)-1;
    d[di] |= ((s[si] >> sb) & mask)<<db;
}
