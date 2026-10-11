import unittest
from flint import acb,ctx
try:
    from bubble_reference import ordered_moment
except ImportError:
    ordered_moment=None

class OrderedIntegralTests(unittest.TestCase):
    def test_tail_bound_is_positive_and_decreases(self):
        import bubble_reference as b
        self.assertTrue(callable(getattr(b,'kernel_tail_bound',None)))
        ctx.dps=100
        self.assertGreater(b.kernel_tail_bound('2.8',100),0)
        self.assertLess(b.kernel_tail_bound('2.8',200),b.kernel_tail_bound('2.8',100))
    def test_ordered_moment_matches_exact_integer_integral(self):
        # Wrong Jacobian or swapping powers changes the unequal-power check.
        self.assertIsNotNone(ordered_moment,'Independent ordered integral not implemented')
        ctx.dps=80
        self.assertTrue(ordered_moment(acb(1),acb(1),acb(2)).contains(acb(1)/32))
        # Integral of u^0 v^1 exp(-2(u+v)), 0<u<v: 3/32.
        self.assertTrue(ordered_moment(acb(0),acb(1),acb(2)).contains(acb(3)/32))

if __name__=='__main__':unittest.main()
