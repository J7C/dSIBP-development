"""Read-only archive integrity checks. Never runs physics or the saved scripts."""
from pathlib import Path
from decimal import Decimal
import csv,hashlib,json,re
ROOT=Path(__file__).resolve().parents[1]
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'),parse_float=str)
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    manifest=ROOT/'provenance/SHA256SUMS.txt'
    listed=set()
    for line in manifest.read_text(encoding='utf-8').splitlines():
        h,rel=line.split('  ',1);p=ROOT/rel
        assert p.is_file(),f'missing: {rel}'
        assert digest(p)==h,f'hash mismatch: {rel}'
        listed.add(rel)
    actual={p.relative_to(ROOT).as_posix() for p in ROOT.rglob('*') if p.is_file()}
    assert actual==listed|{'provenance/SHA256SUMS.txt'},'unlisted files present'
    comparison=read(ROOT/'results/comparison/bubble_comparisons.json')
    with (ROOT/'results/comparison/by_point_and_branch.csv').open(encoding='utf-8',newline='') as f:rows=list(csv.DictReader(f))
    assert len(rows)==15
    for row in rows:
        source=next(x for x in comparison if x['rho']==row['rho'])
        branch=source['branches'][row['branch']]
        for kind in ('native','reference'):
            for component in ('real','imag'):
                assert row[f'{kind}_{component}']==branch[kind][component]
        for kind in ('absolute','relative'):assert row[f'{kind}_error_saved']==branch['error'][kind]
        assert row['absolute_K_truncation_bound_saved']==source['absolute_K_truncation_bound']
    for b,n in [('pp',22),('pm',16),('mp',16),('mm',22)]:
        export=read(ROOT/f'results/native/{b}_export/evaluation_data.json')
        assert export['pointCount']==3 and export['masterCount']==n
        for j,row in enumerate(comparison):
            # Decimal equality is exact representation checking, not recomputing errors.
            for component in ('real','imag'):
                assert Decimal(str(export['values'][j][0][component]))==Decimal(row['branches'][b]['native'][component])
            for key in ('k1','k2'):
                assert Decimal(str(export['points'][j][key]['real']))==Decimal('-'+row['rho'])
        assert export['targetRelativeErrorMet']==[False,False,False]
    broken=[]
    for p in ROOT.rglob('*.md'):
        for link in re.findall(r'\]\(([^)]+)\)',p.read_text(encoding='utf-8')):
            if '://' in link or link.startswith('#'):continue
            if not (p.parent/link.split('#')[0]).exists():broken.append((str(p),link))
    assert not broken,broken
    print(json.dumps({'hashes_verified':len(listed),'comparison_rows_verified':len(rows),'branches_verified':4,'local_links':'valid','physics_calculations_run':False},ensure_ascii=False))
if __name__=='__main__':main()
