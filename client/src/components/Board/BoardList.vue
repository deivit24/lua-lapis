<template>
  <v-row no-gutters>
    <template v-for="cat in makeBoardsList(boards)">
      <v-col class="text-left" cols="4" :key="cat.category">
        <h3 class="mb-2 ml-3">[ {{ cat.category }} ]</h3>
        <ul style="list-style: none; text-align: left">
          <li
            class="board-list"
            @click="$router.push('/boards/' + board.id)"
            v-for="board in cat.boards"
            :key="board.name"
          >
            /{{ board.short_name }}/ - {{ board.name }}
          </li>
        </ul>
      </v-col>
    </template>
  </v-row>
</template>

<script>
export default {
  name: "BoardList",
  props: {
    boards: {
      type: Array,
      required: true,
    },
  },
  computed: {
    catagories() {
      let result = this.boards.map((b) => b.category);
      let catArray = [...new Set(result)];
      let catObjects = [];
      catArray.forEach((element) => {
        let obj = {};
        obj.category = element;
        obj.boards = [];
        catObjects.push(obj);
      });
      return catObjects;
    },
  },
  methods: {
    makeBoardsList(arr) {
      let boards = this.catagories;
      arr.forEach((el) => {
        for (const elm of boards) {
          if (elm.category == el.category) {
            elm.boards.push(el);
          }
        }
      });
      return boards;
    },
  },
};
</script>

<style scoped>
.title:hover,
.board-list:hover {
  cursor: pointer;
  background: rgba(0, 0, 0, 0.5);
  color: white;
}
</style>
