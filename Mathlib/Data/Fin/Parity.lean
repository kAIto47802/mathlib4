/-
Copyright (c) 2023 Yury Kudryashov. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Yury Kudryashov, Iván Renison
-/
import Mathlib.Algebra.Ring.Parity
import Mathlib.Data.Fin.Basic
import Mathlib.Data.ZMod.Defs

/-!
# Parity in `Fin n`

In this file we prove that an element `k : Fin n` is even in `Fin n`
iff `n` is odd or `Fin.val k` is even.
-/

open Fin

namespace Fin

lemma even_of_val {n : ℕ} {k : Fin n} (h : Even k.val) : Even k := by
  have : NeZero n := ⟨k.pos.ne'⟩
  rw [← Fin.cast_val_eq_self k]
  exact h.natCast

lemma odd_of_val {n : ℕ} [NeZero n] {k : Fin n} (h : Odd k.val) : Odd k := by
  rw [← Fin.cast_val_eq_self k]
  exact h.natCast

lemma even_of_odd {n : ℕ} (hn : Odd n) (k : Fin n) : Even k := by
  have : NeZero n := ⟨k.pos.ne'⟩
  rcases k.val.even_or_odd with hk | hk
  · exact even_of_val hk
  · simpa using (hk.add_odd hn).natCast (α := Fin n)


lemma odd_of_odd {n : ℕ} [NeZero n] (hn : Odd n) (k : Fin n) : Odd k := by
  rcases k.val.even_or_odd with hk | hk
  · simpa using (Even.add_odd hk hn).natCast (R := Fin n)
  · exact odd_of_val hk

lemma even_iff_of_even {n : ℕ} (hn : Even n) {k : Fin n} : Even k ↔ Even k.val := by
  rcases hn with ⟨n, rfl⟩
  refine ⟨?_, even_of_val⟩
  rintro ⟨l, rfl⟩
  rw [val_add_eq_ite]
  split_ifs with h <;> simp [Nat.even_sub, *]

lemma odd_iff_of_even {n : ℕ} [NeZero n] (hn : Even n) {k : Fin n} : Odd k ↔ Odd k.val := by
  rcases hn with ⟨n, rfl⟩
  refine ⟨?_, odd_of_val⟩
  rintro ⟨l, rfl⟩
  rw [val_add, val_mul, val_one', show Fin.val 2 = 2 % _ from rfl]
  simp only [Nat.mod_mul_mod, Nat.add_mod_mod, Nat.mod_add_mod, Nat.odd_iff]
  rw [Nat.mod_mod_of_dvd _ ⟨n, (two_mul n).symm⟩, ← Nat.odd_iff, Nat.odd_add_one,
    Nat.not_odd_iff_even]
  simp

/-- In `Fin n`, all elements are even for odd `n`,
otherwise an element is even iff its `Fin.val` value is even. -/
lemma even_iff {n : ℕ} {k : Fin n} : Even k ↔ (Odd n ∨ Even k.val) := by
  refine ⟨fun hk ↦ ?_, or_imp.mpr ⟨(even_of_odd · k), even_of_val⟩⟩
  rw [← Nat.not_even_iff_odd, ← imp_iff_not_or]
  exact fun hn ↦ (even_iff_of_even hn).mp hk

lemma even_iff_imp {n : ℕ} {k : Fin n} : Even k ↔ (Even n → Even k.val) := by
  rw [imp_iff_not_or, Nat.not_even_iff_odd]
  exact even_iff

/-- In `Fin n`, all elements are odd for odd `n`,
otherwise an element is odd iff its `Fin.val` value is odd. -/
lemma odd_iff {n : ℕ} [NeZero n] {k : Fin n} : Odd k ↔ Odd n ∨ Odd k.val := by
  refine ⟨fun hk ↦ ?_, or_imp.mpr ⟨(odd_of_odd · k), odd_of_val⟩⟩
  rw [← Nat.not_even_iff_odd, ← imp_iff_not_or]
  exact fun hn ↦ (odd_iff_of_even hn).mp hk

lemma odd_iff_imp {n : ℕ} [NeZero n] {k : Fin n} : Odd k ↔ (Even n → Odd k.val) := by
  rw [imp_iff_not_or, Nat.not_even_iff_odd]
  exact odd_iff

end Fin
