<template>
  <v-container class="d-flex flex-column justify-center">
    <v-card min-width="450" class="mx-auto" outlined>
      <v-toolbar color="indigo" dark flat>
        <v-toolbar-title>Todos</v-toolbar-title>
      </v-toolbar>

      <v-list dense>
        <template v-for="(item, index) in todos">
          <v-list-item dense :key="index">
            <v-list-item-action>
              <v-checkbox
                v-model="item.done"
                @change="handleDone(item.id, item.done)"
              ></v-checkbox>
            </v-list-item-action>
            <v-list-item-content>
              <v-list-item-title v-html="item.name"></v-list-item-title>
              <v-list-item-subtitle>
                {{ formatDate(item.created, item.edited) }}
              </v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>
        </template>
      </v-list>
    </v-card>
  </v-container>
</template>

<script>
import { TodoApi } from "../services/todos";
import moment from "moment";
export default {
  name: "TodoList",
  data: () => ({
    todos: [],
  }),
  created() {
    this.getTodos();
  },
  methods: {
    async getTodos() {
      const res = await TodoApi.getAllTodos();
      this.todos = res.todos;
    },
    formatDate(createdDate, editedDate) {
      if (editedDate == 0) {
        return "Created " + moment(new Date(createdDate * 1000)).fromNow();
      } else {
        return "Edited " + moment(new Date(editedDate * 1000)).fromNow();
      }
    },
    async handleDone(id, done) {
      console.log(done);
      const data = {
        done: done,
      };
      console.log(data);
      const res = await TodoApi.updateTodo(id, data);
      console.log(res);
    },
  },
};
</script>
