##
## EPITECH PROJECT, 2023
## library sfGames
## File description:
## Makefile
##

SRC		=	vector/set_vector.c			\
			vector/increment_vector.c	\
			vector/scale_vector.c		\
			rect/set_rectangle.c		\
			rect/next_rectangle.c		\
			window/init_window.c		\
			window/create_window.c		\
			window/window_mode.c		\
			window/splash.c				\
			window/actualize_window.c	\
			window/append_layer.c		\
			window/view.c				\
			window/free_window.c		\
			layer/init_layer.c			\
			layer/create_layer.c		\
			layer/switch_layer_show.c	\
			layer/swap_layer.c			\
			layer/append_draw_layer.c	\
			layer/draw_single_layer.c	\
			layer/draw_from_to_layer.c	\
			layer/draw_section_layer.c	\
			layer/draw_layers.c			\
			layer/free_single_layer.c	\
			layer/free_layers.c			\
			data/init_data.c			\
			data/create_data.c			\
			data/set_depth.c			\
			data/set_pos_data.c			\
			data/set_size_data.c		\
			data/set_angle_data.c		\
			data/set_data.c				\
			draw/init_draw.c			\
			draw/create_draw.c			\
			draw/set_data_draw.c		\
			draw/set_attributes_draw.c	\
			draw/set_string_draw.c		\
			draw/set_idle_rect_draw.c	\
			draw/set_animation_draw.c	\
			draw/set_origin_draw.c		\
			draw/get_data_draw.c		\
			draw/get_string_draw.c		\
			draw/modify_draw.c			\
			draw/get_global_bounds_draw.c	\
			draw/switch_draw_show.c		\
			draw/swap_draw.c			\
			draw/hitbox.c				\
			draw/intersect.c			\
			draw/draw_single_draw.c		\
			draw/draw_draws.c			\
			draw/remove_single_draw.c	\
			draw/free_single_draw.c		\
			draw/free_draws.c			\
			sort/sort.c					\
			shape/init_shape.c			\
			shape/create_shape.c		\
			shape/set_data_shape.c		\
			shape/set_attributes_shape.c	\
			shape/get_data_shape.c		\
			shape/modify_shape.c		\
			shape/draw_shape.c			\
			shape/free_shape.c			\
			sprite/init_sprite.c		\
			sprite/set_data_sprite.c	\
			sprite/set_animation_sprite.c	\
			sprite/get_data_sprite.c	\
			sprite/modify_sprite.c		\
			sprite/set_texture_sprite.c	\
			sprite/draw_sprite.c		\
			sprite/free_sprite.c		\
			sprite/create_sprite.c 		\
			text/init_text.c			\
			text/create_text.c			\
			text/set_data_text.c		\
			text/set_attributes_text.c	\
			text/set_string_text.c		\
			text/get_data_text.c		\
			text/modify_text.c			\
			text/set_font_text.c		\
			text/set_string_text.c		\
			text/draw_text.c			\
			text/free_text.c			\
			background/my.c				\
			background/tmx.c			\
			background/parser_csv.c		\
			background/parser_tmx.c		\
			background/create_background.c

OBJ	=	$(SRC:.c=.o)

CC 	=	g++
DEBUG	=	-g3 -p -ggdb3
# Prevents GCC optimizations
RELEASE =  -O0 -fno-builtin
SANITIZE	=	-fsanitize=address,undefined \
-fno-sanitize-recover=address,undefined
AR_LDFLAGS 	= csfml-graphics csfml-window csfml-system
AR_PRELOAD 	=
ANALYZER	=

CFLAGS	+=	-Wall -Wextra -pedantic -fsigned-char	\
-funsigned-bitfields -Wno-unused-parameter -pedantic

NAME	=	libsfGames.a

.PHONY: all re
all: CFLAGS += $(RELEASE)
all: $(NAME)
re: fclean all

.PHONY: debug redebug
debug: CFLAGS += $(DEBUG)
debug: $(NAME)
redebug: fclean debug

.PHONY: sanitize resanitize
sanitize: CFLAGS += $(DEBUG) $(SANITIZE)
sanitize: AR_PRELOAD += asan ubsan
sanitize: $(NAME)
resanitize: fclean sanitize

.PHONY: analyzer reanalyzer
analyzer: ANALYZER += on
analyzer: CFLAGS += $(DEBUG) -fanalyzer
analyzer: $(NAME)
reanalyzer: fclean analyzer

.PHONY: clean_tests
clean_tests:
	@echo "[LIB SFGAMES] Removing criterion temporary files."
	@rm -f *.gcda
	@rm -f *.gcno

.PHONY: tests
tests: clean_tests
	@if [[ "$(shell find ./tests -type f -name '*.c')" == "" ]];			\
		then																\
		echo "[LIB SFGAMES] No .c file in /tests directory.";				\
	else																	\
		echo "[LIB SFGAMES] Building tests;"								\
		$(CC) -g3 $(SRC) ./tests/*.c --coverage -lcriterion					\
			-DRUNNING_CRITERION_TESTS $(CFLAGS) $(LDFLAGS) -o $(NAME);		\
	fi

.PHONY: tests_run
tests_run: clean_tests tests
	@echo "[LIB SFGAMES] Running tests :"
	@./$(NAME)
	@echo "[LIB SFGAMES] Writing line coverage log in logs/line_coverage.log."
	@gcovr --exclude ./tests/ > ./logs/ine_coverage.log
	@echo -n "[LIB SFGAMES] Writing branch coverage log in logs/branch_coverage.log."
	@gcovr --exclude ./tests/ --branches > ./logs/branch_coverage.log

$(NAME): $(OBJ)
	@echo "Building lib graphics..."
	@echo Dependencies: $(AR_PRELOAD) $(AR_LDFLAGS)
	@ar rc -l"$(AR_PRELOAD) $(AR_LDFLAGS)" $(NAME) $(OBJ)
	@if [[ "$(ANALYZER)" != "" ]]; then										\
		echo "[LIB GRAPHICS] GCC Analyzer log in logs/analyzer.log";		\
	fi

%.o: %.c
	@if [[ "$(ANALYZER)" != "" ]]; then										\
		$(CC) -c $(CFLAGS) $< -I ./include/ -o $@ 2>> ./logs/analyzer.log;	\
	else																	\
		$(CC) -c $(CFLAGS) $< -I ./include/ -o $@;							\
	fi

.PHONY: clean_vgcore
clean_vgcore:
	@echo "[LIB SFGAMES] Removing Core Dumped files."
	@rm -f vgcore.*
	@rm -f valgrind*.log.core.*

.PHONY: clean
clean: clean_vgcore clean_tests
	@echo "[LIB SFGAMES] Removing temporary and object files."
	@rm -f ./logs/*.log
	@rm -f *.log
	@rm -f $(OBJ)

.PHONY: fclean
fclean: clean
	@echo "[LIB SFGAMES] Removing binary."
	@rm -f $(NAME)
