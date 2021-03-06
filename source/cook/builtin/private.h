/*
 *	cook - file construction tool
 *	Copyright (C) 1999 Peter Miller;
 *	All rights reserved.
 *
 *	This program is free software; you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation; either version 2 of the License, or
 *	(at your option) any later version.
 *
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 *	along with this program; if not, write to the Free Software
 *	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111, USA.
 *
 * MANIFEST: interface definition for cook/builtin/private.c
 */

#ifndef COOK_BUILTIN_PRIVATE_H
#define COOK_BUILTIN_PRIVATE_H

#include <main.h>

struct string_list_ty; /* existence */
struct expr_position_ty; /* existence */
struct opcode_context_ty; /* existence */

typedef struct builtin_ty builtin_ty;
struct builtin_ty
{
	char	*name;
	int	(*interpret)_((struct string_list_ty *,
			const struct string_list_ty *,
			const struct expr_position_ty *,
			const struct opcode_context_ty *));
	int	(*script)_((struct string_list_ty *,
			const struct string_list_ty *,
			const struct expr_position_ty *,
			const struct opcode_context_ty *));
};

int builtin_interpret _((builtin_ty *, struct string_list_ty *,
	const struct string_list_ty *, const struct expr_position_ty *,
	const struct opcode_context_ty *));
int builtin_script _((builtin_ty *, struct string_list_ty *,
	const struct string_list_ty *, const struct expr_position_ty *,
	const struct opcode_context_ty *));

#endif /* COOK_BUILTIN_PRIVATE_H */
